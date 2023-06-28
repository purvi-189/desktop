const erc20abi = require("../artifacts/@openzeppelin/contracts/token/ERC20/ERC20.sol/ERC20.json");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const {
  Contract,
} = require("hardhat/internal/hardhat-network/stack-traces/model");

describe("Dao", function () {
  let dao;
  let company;
  let token;
  let owner;
  let user1; // 1 2 3 dao member
  let user2;
  let user3;
  let user4;
  let user5;
  let user6;

  let contract;

  beforeEach(async function () {
    [owner, user1, user2, user3, user4, user5, user6] =
      await ethers.getSigners();

    const Company = await ethers.getContractFactory("Company");
    company = await Company.deploy();
    await company.deployed();

    const Token = await ethers.getContractFactory("NewToken");
    token = await Token.deploy("10000000000000000000000", "10000000000000000000000" );
    await token.deployed();

    const Dao = await ethers.getContractFactory("Dao");
    dao = await Dao.deploy(company.address, token.address);
    await dao.deployed();

    contract = new ethers.Contract(token.address, erc20abi.abi, owner);
  });

    it("should add a member to the DAO", async function () {
      await contract.transfer(dao.address, 1000);

      const tokenAmount = 10; // Adjust the token amount as needed
      expect(await contract.balanceOf(dao.address)).to.be.equal(1000); //this is of contract
      const price = await token.getTokenPrice();
      const val = price/1000000000000000000;
      console.log(val);
    // expect(await dao.isMemberMapping[user1.address] ).to.be.false;

      // await expect(
      //   dao.connect(user1).addMember(tokenAmount, { value: (1* price).toString() })
      // ).to.be.revertedWith("Your Amount Value is Low for Transaction");

        // console.log(await contract.balanceOf(dao.address));

    //  await expect(
    //   dao.connect(user1).addMember(200, { value: (200 * price) })
    // ).to.be.revertedWith("Contract Balance is Low");

//     //ob     // to check about no of token ==10
    // await dao.connect(user1).addMember(10, { value: 10 * price }),
    // await contract.balanceOf(user1.address); // ans 10

//     //     //---- checking length if array get all proposal:
//     await dao.connect(user1).createProposal("description", "image", true, 100, {
//       value: 1000000000000000,
//     });
//     const data = await dao.getAllProposal();
//     expect(data.length).to.be.equal(1);

// //     //     // --> checking member of DAO
//     const isMember = await dao.isMember(user1.address);
//     expect(isMember).to.be.true;

//     //     // not a member of DAO
//     const val = await dao.getConfigs();
//     await expect(
//       dao.connect(user2).createProposal("description", "image", true, 100, {
//         value: val[0],
//       })
//     ).to.be.revertedWith("You are not a member of DAO");

//     //     //proposal stake value is low
//     await expect(
//       dao.connect(user1).createProposal("description", "image", true, 100, {
//         value: val[0] - 1,
//       })
//     ).to.be.revertedWith("Your Proposal Stake Value is Low");

//     //     //creating user2, 3, 5,6 member if dao
//     await dao.connect(user2).addMember(20, { value: 20 * price }),
//       await contract.balanceOf(user2.address);
//     await dao.connect(user3).addMember(30, { value: 30 * price }),
//       await contract.balanceOf(user3.address);
//     await dao.connect(user5).addMember(30, { value: 30 * price }),
//       await contract.balanceOf(user5.address);
//     await dao.connect(user6).addMember(30, { value: 30 * price }),
//       await contract.balanceOf(user6.address);

// //         // UPVOTE
//     await dao.connect(user2).upvote(1, { value: val[1] });
//     await dao.connect(user3).upvote(1, { value: val[1] });
//     const proposal = await dao.getProposal(1);

//     expect(proposal.upvote).to.equal(2);
//     expect(proposal.upvoters.length).to.equal(2);
//     expect(proposal.upvoters[0]).to.equal(user2.address);

//     // Try to upvote the proposal as a non-member
//     await expect(
//       dao.connect(user4).upvote(proposal.id, { value: val[1] })
//     ).to.be.revertedWith("You are not a member of DAO");

//     //     // Try to upvote the proposal as the proposal creator
//     await expect(
//       dao.connect(user1).upvote(proposal.id, { value: val[1] })
//     ).to.be.revertedWith("You are a proposal creator so you can not vote");

//     //     // user already voted
//     //     //  Upvote the proposal  user2 has already voted
//     //     // -->Try to upvote the same proposal again
//     await expect(
//       dao.connect(user2).upvote(proposal.id, { value: val[1] })
//     ).to.be.revertedWith("You have already voted");

//       // voting stake low
//       await expect(
//         dao.connect(user6).upvote(proposal.id, { value: val[1] - 1 })
//       ).to.be.revertedWith("Your Voting Stake is Low");

//     //     // voting-----    //@@@@@@@@@@@@@@@@@@@@@@@@@

//     await expect( dao.getProposalResult(1)).to.be.revertedWith("Voting has not ended yet");

//     const currentTime = (await ethers.provider.getBlock("latest")).timestamp;
//     //     // Add 1 minute (60 seconds) to the current timestamp
//     const futureTime = currentTime + 260;
//     //     // Advance the block timestamp to the future time
//     await ethers.provider.send("evm_setNextBlockTimestamp", [futureTime]);
//     await ethers.provider.send("evm_mine");
//     await expect(dao.getProposalResult(10)).to.be.revertedWith("Proposal does not exist")
//     // await company.connect(user1).setUser( user1.name, user1.username, user1.email, user1.companyName, user1.country, user1.companyProfileImage)
//     await company.connect(user1).setUser( "User 1", "user1",   "user1@gmail.com", "Company 1",  "Country 1",  "Image 1");
    
//     // await dao.getProposalResult(1)

      
//     // //     // //------> DOWNVOTE <-------------
//     // //     // user 5 downvote
//         await dao.connect(user5).downvote(1, { value: val[1] });
//         // console.log(await dao.getAllProposal());
//         const test = await dao.getProposal(1);
//         expect(test.downvote).to.equal(1);
//         expect(test.downvoters.length).to.equal(1);
//         expect(test.downvoters[0]).to.equal(user5.address);

//         // Try to downvote the proposal as a non-member
//         await expect(
//           dao.connect(user4).downvote(proposal.id, { value: val[1] })
//         ).to.be.revertedWith("You are not a member of DAO");

//         // Try to downvote the proposal as the proposal creator
//         await expect(
//           dao.connect(user1).downvote(proposal.id, { value: val[1] })
//         ).to.be.revertedWith("You are a proposal creator so you can not vote");

//         // -->Try to downvote the same proposal again
//         await expect(
//           dao.connect(user5).downvote(proposal.id, { value: val[1] })
//         ).to.be.revertedWith("You have already voted");

//         // voting stake low
//         await expect(
//           dao.connect(user6).downvote(proposal.id, { value: val[1] - 1 })
//         ).to.be.revertedWith("Your Voting Stake is Low");

//        // voting-----

//     // await expect( dao.getProposalResult(1)).to.be.revertedWith("Voting has not ended yet");
//     // const currentTime = (await ethers.provider.getBlock("latest")).timestamp;
//     // //     // Add 1 minute (60 seconds) to the current timestamp
//     // const futureTime = currentTime + 260;
//     // //     // Advance the block timestamp to the future time
//     // await ethers.provider.send("evm_setNextBlockTimestamp", [futureTime]);
//     // await ethers.provider.send("evm_mine");
//     // await expect(dao.getProposalResult(10)).to.be.revertedWith("Proposal does not exist")
//     // // await company.connect(user1).setUser( user1.name, user1.username, user1.email, user1.companyName, user1.country, user1.companyProfileImage)
//     // await company.connect(user1).setUser( "User 1", "user1",   "user1@gmail.com", "Company 1",  "Country 1",  "Image 1");
    
//     await dao.getProposalResult(1)
    
//         // -----> RESULT ------------->

//         await expect(dao.getProposalResult(100)).to.be.revertedWith(
//           "Proposal does not exist"
//         );

});

});

