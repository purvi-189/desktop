// const { expect } = require("chai");
// const { ethers } = require("hardhat");
// const { Contract } = require("hardhat/internal/hardhat-network/stack-traces/model");

// // const companyAbi = require("../artifacts/@openzeppelin/contracts/Company.sol/Company.json");

// describe("Company", function () {
//   let company;
//   let user1;
//   let user2;
//   let dao, token;

//   beforeEach(async function () {
//     const Company = await ethers.getContractFactory("Company");
//     companyInstance = await Company.deploy();
//     await companyInstance.deployed();

//     const Token = await ethers.getContractFactory("NewToken");
//     tokenInstance = await Token.deploy(
//       "10000000000000000000000",
//       "10000000000000000000000"
//     );
//     await tokenInstance.deployed();

//     const Dao = await ethers.getContractFactory("Dao");
//     daoInstance = await Dao.deploy(companyInstance.address, tokenInstance.address);
//     await daoInstance.deployed();

//     [user1, user2] = await ethers.getSigners();
//     const tx = await companyInstance.setUser(
//       "User 1",
//       "user1",
//       "user1@gmail.com",
//       "Company 1",
//       "Country 1",
//       "Image 1"
//     );
//     // console.log(tx);
//     // dao.connect(companyInstance).addmember(20, { value: 20 * price });
//     // const Contract = await ethers.getContractAt(
//     //   companyAbi,
//     //   companyInstance.address
//     // );
//   });

//   it("should not allow registering an already registered company", async () => {
//     await expect(
//       companyInstance.setUser(
//         "User 1",
//         "user1",
//         "user1@gmail.com",
//         "Company 1",
//         "Country 1",
//         "Image 1"
//       )
//     ).to.be.revertedWith("Company is already registered");
//   });

//   it("should revert if the credit is not available", async function () {

//    const credit = await companyInstance.totalCreditMapping(user1.address);
//     console.log(credit);
//     await companyInstance.issue

//     // await expect(
//     //   company.createOrder(120, 1, user1.address)
//     // ).to.be.revertedWith("You don't have much credit available");
//   });

//   //   it("should create and buy credits", async function () {
//   //     // if(user1.address == daoAddresss){
//   //     await company.issueCredit(company.address, 100);
//   //     await company.createOrder(50, 1, company.address);
//   //     const orderId = await company.getUserOrders(company.address);
//   //     const order = await company.Orderstruct(orderId[0]);

//   //     expect(order.isSell).to.equal(false);
//   //     expect(order.credit).to.equal(50);
//   //     expect(order.price).to.equal(1);
//   //     expect(order.seller).to.equal(company.address);

//   //     const value = order.credit * order.price;
//   //     await company.connect(user2).buycredit(orderId[0], { value: value });

//   //     const user1Credit = await company.totalcredit(company.address); // user1 seller
//   //     const user2Credit = await company.totalcredit(user2.address); //buyer
//   //     const creditToSell = await company.credittoSell(company.address);
//   //     const updatedOrder = await company.Orderstruct(orderId[0]);
//   //     expect(user1Credit).to.equal(50);
//   //     expect(user2Credit).to.equal(50);
//   //     expect(creditToSell).to.equal(0);
//   //     expect(updatedOrder.isSell).to.equal(true);

//   //     // seller cannot buy their own credits
//   //     expect(company.connect(company).buycredit(orderId)).to.be.revertedWith(
//   //       "Seller cannot buy their own credit"
//   //     );

//   //   });

//   //   it("should revert if order has already been filled", async function () {
//   //     await company.issueCredit(user1.address, 100);
//   //     const orderId = 1;
//   //     const sellCredit = 50;
//   //     const creditPrice = 2;
//   //     const expectedTotalPrice = sellCredit * creditPrice;

//   //     // Create the order and mark it as filled
//   //     await company
//   //       .connect(user1)
//   //       .createOrder(sellCredit, creditPrice, user1.address);
//   //     await company
//   //       .connect(user2)
//   //       .buycredit(orderId, { value: expectedTotalPrice });

//   //     // Try to buy the credit from the same order again
//   //     await expect(
//   //       company.connect(user2).buycredit(orderId, { value: expectedTotalPrice })
//   //     ).to.be.revertedWith("Order has been filled");
//   //   });

//   //   it("should return if orderId does not exist", async function () {
//   //     await expect(company.buycredit(100)).to.be.revertedWith(
//   //       "Order does not exist"
//   //     );
//   //   });
  
// });
