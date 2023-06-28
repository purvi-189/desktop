// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// //import "hardhat/console.sol";

// contract  Company {                           //UserInfo
//     struct User {
//         string name;
//         string username;
//         string email;
//         string companyName;
//         string country;
//         string companyProfileImage;
//       //  uint carbonCredits;

//     }
    
//     struct Order {
//         uint orderId;
//         uint credit;
//         uint price;
//         bool isSell;  // check order
//         address seller;

//     }
    
//     mapping(address => User) private users;
//     mapping (address => bool) public iscompaniesAdd;
//     mapping (address => uint) public totalcredit;
//    // mapping (address => Order[]) public orders;
//     mapping (address => uint) public credittoSell;       // Create order-> store credit
//     mapping (address => uint []) public OrderstructId;    
//     mapping (uint => Order) public Orderstruct;

//     //uint public availableCredit;
//     uint public orderCount;
  
//     function setUser(string memory _name,string memory _username , string memory _email, string memory _companyName, string memory _country, string memory _companyProfileImage) public {
//         //  Check if the company is already registered
//         require(!iscompaniesAdd[msg.sender], "Company is already registered");
//         users[msg.sender] = User(_name,_username,_email, _companyName, _country,_companyProfileImage);
//         // Register the company

//         iscompaniesAdd[msg.sender] = true;
//     }
    
//     function getUser(address _address) public view returns ( User memory) {
//             return users[_address];
//             //return User Data
//     }

//     function getUserOrders(address _user) public view returns(uint[] memory) {
//               return OrderstructId[_user];
//     } 

//     function issueCredit(address _address, uint _credits) public {
//         // Check if the sender is a registered company
//         require(iscompaniesAdd[_address], "Company is not registered");
        
//         // store the company's total credit
//         totalcredit[_address] += _credits;
//     }

//     function createOrder(uint _sellcredit,uint _price,address _address) public {
//         require(_sellcredit<=totalcredit[msg.sender],"You don't have much credit available");

//         orderCount++;
//         Orderstruct[orderCount]=Order(orderCount,_sellcredit,_price,false,_address);
//         OrderstructId[msg.sender].push(orderCount);

//         totalcredit[msg.sender] -=_sellcredit;
//         credittoSell[msg.sender] +=_sellcredit;
//     }

//     function buycredit(uint _orderId) public payable  
//     {
//         require(!Orderstruct[_orderId].isSell, "Order has been filled");
//         require(msg.value == (Orderstruct[_orderId].credit * Orderstruct[_orderId].price), "Not enough amount");

//         totalcredit[msg.sender] += Orderstruct[_orderId].credit;
//         credittoSell[Orderstruct[_orderId].seller] -= Orderstruct[_orderId].credit;
//         Orderstruct[_orderId].isSell = true;
//         uint totalprice = Orderstruct[_orderId].credit * Orderstruct[_orderId].price;
//         payable(Orderstruct[_orderId].seller).transfer(totalprice);
//     }
// }
