// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Company.sol";
import "./NewToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
         
contract Dao is Ownable {
    struct Proposal {
        uint id;
        string description;
        string image;
        bool Type;  //false for offset and true for emission
        uint value; 
        address payable creator;
        uint upVote;
        uint downVote;
        uint proposedAt;
        uint proposalExpiresAt;
        string status; //   reject , accept , pending
        address payable[] upVoters; 
        address payable[] downVoters; 
    }

    Company public company;
    NewToken public Token;

    constructor(address _companyAddress , address _ErcTokenAddress){
        company = Company(_companyAddress);
        Token = NewToken(_ErcTokenAddress);
    }

    mapping(uint => Proposal) public proposalsMapping;
    mapping(address => uint[]) public proposalAddressMapping;
    mapping(address => bool) public isMemberMapping;
   // mapping(uint=>address[]) public voters;
    mapping(address => uint) public memberWithdrawableAmountMapping;
    mapping(uint => mapping(address => bool)) hasVoteMapping;
    
    address[] public allmembersDAO;
    uint public proposalCount;
    uint public proposalStake = 5000000000000000000000; //  5000 ether
    uint public votingStake = 1000000000000000000000;   //   1000 ether
    uint public votingTimePeriod = 86400; // 1 day in seconds
    uint public carbonCredit;
    uint public globalLimit=5000; 
    uint public votingPercent  = 25;
  

    function createProposal(string memory _description, string memory _image, bool _Type , uint _value) public  payable{
        require(isMemberMapping[msg.sender],"You are not a member of DAO"); 
        require(msg.value==proposalStake,"Your Proposal Stake Value is Low");

        proposalCount++;
        uint _proposalExpiresAt = SafeMath.add(block.timestamp, votingTimePeriod);
        proposalsMapping[proposalCount] = Proposal(proposalCount, _description, _image, _Type, _value,payable(msg.sender), 0, 0, block.timestamp, _proposalExpiresAt,"",new address payable[](0), new address payable[](0));             
        proposalAddressMapping[msg.sender].push(proposalCount);
    }

    function getAllProposal() public view returns (Proposal[] memory){
        Proposal[] memory allProposals = new Proposal[](proposalCount);
        for(uint i=0;i<proposalCount;i++){
               allProposals[i] = proposalsMapping[i+1];
        }
        return allProposals;      // return proposal info
    }

    function getUserProposals(address _member)public view returns(uint[] memory){
        return proposalAddressMapping[_member];
    }

    function getProposal(uint _id)public view returns(Proposal memory){
        return proposalsMapping[_id];
    }

    function addMember(uint _amount) public payable{
        require(msg.value == (_amount * Token.getTokenPrice()), "Your Amount Value is Low for Transaction");
        require(Token.balanceOf(address(this))>=_amount,"Contract Balance is Low");
        if(!isMemberMapping[msg.sender]){
            isMemberMapping[msg.sender]=true;                   // add member in DAO
            allmembersDAO.push(msg.sender);
        } 
        Token.transfer(msg.sender,_amount);
    }

    function upVote(uint _id) public payable {
        require(isMemberMapping[msg.sender],"You are not a member of DAO");  // member of dao
        require(msg.sender != proposalsMapping[_id].creator,"You are a proposal creator so you can not vote");// proposal creator cannot vote
        require(!hasVoteMapping[_id][msg.sender], "You have already voted");       // member can vote only once
        require(proposalsMapping[_id].proposalExpiresAt >=block.timestamp,"Voting time ended"); // proposal time expire
        require(msg.value==votingStake,"Your Voting Stake is Low");
        proposalsMapping[_id].upVote +=1;
        hasVoteMapping[_id][msg.sender]=true;
        proposalsMapping[_id].upVoters.push(payable(msg.sender));
    } 

    function downVote(uint _id) public payable {
        require(isMemberMapping[msg.sender],"You are not a member of DAO");  // member of dao
        require(msg.sender != proposalsMapping[_id].creator,"You are a proposal creator so you can not vote");// proposal creator cannot vote
        require(!hasVoteMapping[_id][msg.sender], "You have already voted");             // member can vote only once
        require(proposalsMapping[_id].proposalExpiresAt >=block.timestamp,"Voting time ended"); // proposal time expire
        require(msg.value==votingStake,"Your Voting Stake is Low");
        proposalsMapping[_id].downVote +=1;
        hasVoteMapping[_id][msg.sender]=true;
        proposalsMapping[_id].downVoters.push(payable(msg.sender));
    } 

    function getProposalResult(uint _proposalId) public returns (string memory) {
       // Proposal storage proposal = proposalsMapping[_proposalId];

        // check if proposal exists and voting has ended
        require(proposalsMapping[_proposalId].proposedAt != 0, "Proposal does not exist");
       // require(bytes(proposalsMapping[_proposalId].status).length == 0, "Result has already been Declared");
       
        require(
            keccak256(bytes(proposalsMapping[_proposalId].status)) != keccak256(bytes("Accept")) ||
            keccak256(bytes(proposalsMapping[_proposalId].status)) != keccak256(bytes("Reject")) ||
            keccak256(bytes(proposalsMapping[_proposalId].status)) != keccak256(bytes("Questionable"))
        );

        require(block.timestamp > proposalsMapping[_proposalId].proposalExpiresAt, "Voting has not ended yet");
       
        uint totalVotes = proposalsMapping[_proposalId].upVote + proposalsMapping[_proposalId].downVote;
        uint minimumVotes = (allmembersDAO.length * votingPercent) / 100;

        if(totalVotes==0){
            proposalsMapping[_proposalId].status = "Questionable";
        }

        else if (totalVotes < minimumVotes) {
            proposalsMapping[_proposalId].status = "Questionable";
        } 
        else if (proposalsMapping[_proposalId].upVote > proposalsMapping[_proposalId].downVote) {
            proposalsMapping[_proposalId].status = "Accept";

            if(proposalsMapping[_proposalId].Type==false)
            {
                carbonCredit=proposalsMapping[_proposalId].value;
                company.issueCredit(proposalsMapping[_proposalId].creator,carbonCredit);
            }
            else {
                carbonCredit=globalLimit-proposalsMapping[_proposalId].value;
                company.issueCredit(proposalsMapping[_proposalId].creator,carbonCredit);
            }
            
            // give back proposal stake and voting stake to upVoters
            uint upVotersStake = proposalsMapping[_proposalId].upVote * votingStake;
            memberWithdrawableAmountMapping[proposalsMapping[_proposalId].creator] += proposalStake;
            if (upVotersStake > 0) {
                for (uint i = 0; i < proposalsMapping[_proposalId].upVoters.length; i++) {
                    memberWithdrawableAmountMapping[proposalsMapping[_proposalId].upVoters[i]] += votingStake;
                }
            }
    } 
    else {
        proposalsMapping[_proposalId].status = "Reject";

        // give back voting stake to downVoters
        uint downVotersStake = proposalsMapping[_proposalId].downVote * votingStake;
        if (downVotersStake > 0) {
            for (uint i = 0; i < proposalsMapping[_proposalId].downVoters.length; i++) {
                memberWithdrawableAmountMapping[proposalsMapping[_proposalId].upVoters[i]] += votingStake;
            }
        }
    }
        return proposalsMapping[_proposalId].status;
    }

    function setProposalStake(uint _proposalstake) public onlyOwner {
        proposalStake = _proposalstake;
    }

    function setVotingStake(uint _votingstake) public onlyOwner {
        votingStake = _votingstake;
    }

    function setVotingTimePeriod(uint _votingtimeperiod) public onlyOwner {
        votingTimePeriod = _votingtimeperiod;
    }

    function setVotingPercent(uint _votingPercent) public onlyOwner {
        votingPercent = _votingPercent; 
    }

    function setLimit(uint _limit) public onlyOwner{
        globalLimit=_limit;
    }

    function getConfigs() public view returns(uint,uint,uint,uint,uint) {
        return (proposalStake,votingStake,votingTimePeriod,votingPercent,globalLimit);
    }

    function withdrawFromContract(uint _amount) public payable onlyOwner {
    require(address(this).balance >= _amount, "Insufficient contract balance");
    payable(msg.sender).transfer(_amount);
    }

    function withdrawTokenFromContract(address _address,uint _amount) public payable onlyOwner {
            IERC20 TokenContract = IERC20(_address);
            require(TokenContract.balanceOf(address(this)) >= _amount, "Insufficient token balance in the contract");
            TokenContract.transfer(msg.sender,_amount);
    }

    function withdrawStake() public  {
        require(isMemberMapping[msg.sender],"You are not a member of DAO"); 
      //  uint stakeAmount = memberWithdrawableAmountMapping[msg.sender];
        require(memberWithdrawableAmountMapping[msg.sender] > 0, "No stake available");
         memberWithdrawableAmountMapping[msg.sender] = 0; 
        payable(msg.sender).transfer(memberWithdrawableAmountMapping[msg.sender]);
    }
}