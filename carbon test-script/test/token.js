// const { expect } = require("chai");
// const erc20abi = require("../artifacts/@openzeppelin/contracts/token/ERC20/ERC20.sol/ERC20.json");

// const {
//   Contract,
// } = require("hardhat/internal/hardhat-network/stack-traces/model");

// describe("NewToken", function () {
//   let owner;
//   let addr1;
//   let newToken;
//   let contract;

//   beforeEach(async function () {
//     [owner, addr1] = await ethers.getSigners();
//     const NewToken = await ethers.getContractFactory("NewToken");
//     newToken = await NewToken.deploy(
//       "1000000000000000000000",
//       "1000000000000000000000"
//     );
//     await newToken.deployed();

//     await newToken.transfer(newToken.address, "100000000000000000");

//     contract = new ethers.Contract(newToken.address, erc20abi.abi, owner);
//   });

//   it("should have correct name, symbol, and initial supply", async function () {
//     expect(await newToken.name()).to.equal("CarboEx");
//     expect(await newToken.symbol()).to.equal("CX");
//     expect(await newToken.totalSupply()).to.equal("1000000000000000000000");
//   });

//   it("should mint tokens by owner", async function () {
//     await newToken.connect(owner).mint(100000000);
//     expect(await newToken.totalSupply()).to.equal("1000000000000100000000");
//     const ownerBalance = await newToken.balanceOf(owner.address);
//     expect(ownerBalance).to.equal("999900000000100000000");
//   });

//   it("should withdraw tokens from the contract", async function () {
//     await newToken
//       .connect(owner)
//       .withdrawTokenFromContract(1000, newToken.address);
//     const updatedBalance = await newToken.balanceOf(owner.address);
//     expect(updatedBalance).to.equal("999900000000000001000");
//   });


//   it("should set token price by owner", async function () {
//     await newToken.connect(owner).setTokenPrice("1000000000000000000000");
//     const tokenPrice = await newToken.getTokenPrice();
//     expect(tokenPrice).to.equal("1000000000000000000000" );
//   });

//           it("should transfer token", async function (){
//             await newToken.tokenTransfer(newToken.address, 100);
//           })

//   //   //       it("should revert if insufficient contract balance" , async function(){
//   //   //         expect(newToken.withdrawFromContract(1100)).to.be.revertedWith("Insufficient contract balance");
//   //   //       })
//   // });
// });
