// const { expect } = require('chai');
// const { ethers } = require('hardhat');
// // const { expectEvent, expectRevert } = require('@openzeppelin/test-helpers');


// describe('Dao', function () {
//   let dao;
//   let token;
//   let company;
//   let owner;
//   let member1;
//   let member2;
//   let addr2;

//   beforeEach(async function () {

//     const NewToken = await ethers.getContractFactory('NewToken');
//     token = await NewToken.deploy(1000);
//     // console.log(token.address); 

//     const Company = await ethers.getContractFactory('Company');
//     company = await Company.deploy();
//     // console.log(company.address); 


//     const Dao = await ethers.getContractFactory('Dao');
//     dao = await Dao.deploy(company.address , token.address);    

//     [owner, member1, member2] = await ethers.getSigners();

//     await token.transfer(member1.address, 1000);
//     await token.transfer(member2.address, 2000);
//   });

//  ////---- === MEMBER

//   // it("should add a member to the DAO", async function () {

//   //   const tokenAmount =  100 ; 

//   //   await token.transfer(dao.address, tokenAmount);
//   //   await dao.connect(member1).addmember(tokenAmount);

//   //   expect(await dao.isMember(member1.address)).to.be.true;
//   // });

//   // ==========================

//   it('should create a proposal', async function () {
//   const description = 'Proposal 1';
//   const image = 'Image 1';
//   const proposalValue = 100;
//   const proposalStake = 1000000000000000;
// // 

//   await dao.connect(member1).createProposal(description, image, true, proposalValue, { value: proposalStake });
//   const proposal = await dao.getProposal(1);

//   expect(proposal.description).to.equal(description);
//   expect(proposal.image).to.equal(image);
//   expect(proposal.value).to.equal(proposalValue);
//   expect(proposal.creator).to.equal(member1.address);
//   // expect(proposal.status).to.equal();
// });




// });
