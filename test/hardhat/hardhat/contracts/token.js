const {expect } = require('chai');
const { ethers } = require('hardhat');
const { isCallTrace } = require('hardhat/internal/hardhat-network/stack-traces/message-trace');

describe("Token Contract" , function(){

    it("depl should assign total supply to owner", async function(){

        const [owner] = await ethers.getSigners();
        console.log("signer obj: ",owner);

        const Token = await ethers.getContractFactory("Token") //instance contract

        const hardhatToken = await Token.deploy(); // deploy contract

        const ownerBal = await hardhatToken.balanceOf(owner.address);
        console.log("owner add: ",ownerBal);

        expect(await hardhatToken.totalSupply() ).to.equal(ownerBal);

    })
})