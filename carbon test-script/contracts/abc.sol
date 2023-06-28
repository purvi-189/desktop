// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "./Company.sol";
// import "./NewToken.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// contract Dao is Ownable {
//     struct Proposal {
//         uint id;
//         string description;
//         string image;
//         bool Type;  //false for offset and true for emission
//         uint value;
//         address payable creator;
//         uint upvote;
//         uint downvote;
//         uint proposedAt;
//         uint proposalExpiresAt;
//         string status; //   reject , accept , pending
//         address payable[] upvoters; 
//         address payable[] downvoters; 
//     }

//     Company public company;
//     NewToken public Token;

//     constructor(address _companyAddress , address _ErcTokenAddress){
//         company = Company(_companyAddress);
//         Token = NewToken(_ErcTokenAddress);
//     }

//     mapping(uint => Proposal) public Proposals;
//     mapping(address => uint[]) public ProposalAddress;
//     mapping(address => bool) public isMember;
//     mapping(uint=>address[]) public voters;
//     mapping(address => uint) public memberWithdrawableAmount;
//     mapping(uint => mapping(address => bool)) hasVote;
    
//     address[] public allmembersDAO;
//     uint public proposalCount;
//     uint public proposalstake = 1000000000000000; //  .0001 ether
//     uint public votingstake = 100000000000000;   //   .00001 ether
//     uint public votingtimeperiod = 240; // 1 day in seconds
//     uint public carbonCredit;
//     uint public globallimit=1000;
//     uint public votingPercent=5;
  

//     function createProposal(string memory _description, string memory _image, bool _Type , uint _value) public  payable{
//         require(isMember[msg.sender],"You are not a member of DAO"); 
//         require(msg.value==proposalstake,"Your Proposal Stake Value is Low");

//         proposalCount++;
//         uint _proposalExpiresAt = SafeMath.add(block.timestamp, votingtimeperiod);
//         Proposals[proposalCount] = Proposal(proposalCount, _description, _image, _Type, _value,payable(msg.sender), 0, 0, block.timestamp, _proposalExpiresAt,"",new address payable[](0), new address payable[](0));             
//         ProposalAddress[msg.sender].push(proposalCount);
//     }

//     function getAllProposal() public view returns (Proposal[] memory){
//         Proposal[] memory allProposals = new Proposal[](proposalCount);
//         for(uint i=0;i<proposalCount;i++){
//                allProposals[i] = Proposals[i+1];
//         }
//         return allProposals;      // return proposal info
//     }

//     function getUserProposals(address _member)public view returns(uint[] memory){
//         return ProposalAddress[_member];
//     }

//     function getProposal(uint _id)public view returns(Proposal memory){
//         return Proposals[_id];
//     }

//     function addmember(uint _amount) public payable{
//         require(msg.value == (_amount * Token.gettokenPrice() ) , "Your Amount Value is Low for Transaction");
//         require(Token.balanceOf(address(this))>=_amount,"Contract Balance is Low");
        
//         if(!isMember[msg.sender]){
//             isMember[msg.sender]=true;                   // add member in DAO
//             allmembersDAO.push(msg.sender);
//         } 
//         Token.transfer(msg.sender,_amount);
//     }

//     function upvote(uint _id) public payable {
//         require(isMember[msg.sender],"You are not a member of DAO");  // member of dao
//         require(msg.sender != Proposals[_id].creator,"You are a proposal creator so you can not vote");// proposal creator cannot vote
//         require(!hasVote[_id][msg.sender], "You have already voted");       // member can vote only once
//         require(Proposals[_id].proposalExpiresAt >=block.timestamp,"Voting time ended"); // proposal time expire
//         require(msg.value==votingstake,"Your Voting Stake is Low");
//         Proposals[_id].upvote +=1;
//         hasVote[_id][msg.sender]=true;
//         Proposals[_id].upvoters.push(payable(msg.sender));
//     } 

//     function downvote(uint _id) public payable {
//         require(isMember[msg.sender],"You are not a member of DAO");  // member of dao
//         require(msg.sender != Proposals[_id].creator,"You are a proposal creator so you can not vote");// proposal creator cannot vote
//         require(!hasVote[_id][msg.sender], "You have already voted");             // member can vote only once
//         require(Proposals[_id].proposalExpiresAt >=block.timestamp,"Voting time ended"); // proposal time expire
//         require(msg.value==votingstake,"Your Voting Stake is Low");
//         Proposals[_id].downvote +=1;
//         hasVote[_id][msg.sender]=true;
//         Proposals[_id].downvoters.push(payable(msg.sender));
//     } 

//     function getProposalResult(uint _proposalId) public returns (string memory) {
//         Proposal storage proposal = Proposals[_proposalId];

//         // check if proposal exists and voting has ended
//         require(proposal.proposedAt != 0, "Proposal does not exist");
//         require(bytes(proposal.status).length == 0, "Result has already been Declared");
//         require(block.timestamp > proposal.proposalExpiresAt, "Voting has not ended yet");
       
//         uint totalVotes = proposal.upvote + proposal.downvote;
//         uint minimumVotes = (allmembersDAO.length * votingPercent) / 100;

//         if(totalVotes==0){
//             proposal.status = "Questionable";
//         }
//         else if (totalVotes < minimumVotes) {
//             proposal.status = "Questionable";
//         }
//         else if (proposal.upvote > proposal.downvote) {
//             proposal.status = "Accept";

//             if(proposal.Type==false)  // offset
//             {
//                 carbonCredit=proposal.value;
//                 company.issueCredit(proposal.creator,carbonCredit);
//             }
//             else {
//                 carbonCredit=globallimit-proposal.value;
//                 company.issueCredit(proposal.creator,carbonCredit);
//             }
            
//             // give back proposal stake and voting stake to upvoters
//             uint upvotersStake = proposal.upvote * votingstake;
//             memberWithdrawableAmount[proposal.creator] += proposalstake;
//             if (upvotersStake > 0) {
//                 for (uint i = 0; i < proposal.upvoters.length; i++) {
//                     memberWithdrawableAmount[proposal.upvoters[i]] += votingstake;
//                 }
//             }
//     } 
//     else {
//         proposal.status = "Reject";

//         // give back voting stake to downvoters
//         uint downvotersStake = proposal.downvote * votingstake;
//         if (downvotersStake > 0) {
//             for (uint i = 0; i < proposal.downvoters.length; i++) {
//                 memberWithdrawableAmount[proposal.upvoters[i]] += votingstake;
//             }
//         }
//     }
//         return proposal.status;
//     }

//     function setproposalstake(uint _proposalstake) public onlyOwner {
//         proposalstake = _proposalstake;
//     }

//     function setvotingstake(uint _votingstake) public onlyOwner {
//         votingstake = _votingstake;
//     }

//     function setvotingtimeperiod(uint _votingtimeperiod) public onlyOwner {
//         votingtimeperiod = _votingtimeperiod;
//     }

//     function setvotingPercent(uint _votingPercent) public onlyOwner {
//         votingPercent = _votingPercent; 
//     }

//     function setLimit(uint _limit) public onlyOwner{
//         globallimit=_limit;
//     }

//     function getConfigs() public view returns(uint,uint,uint,uint,uint) {
//         return (proposalstake,votingstake,votingtimeperiod,votingPercent,globallimit);
//     }
   
// }
