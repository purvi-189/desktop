// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract  Company is Ownable {                           //UserInfo
    struct User {
        string name;
        string userName;
        string email;
        string companyName;
        string country;
        string companyProfileImage;
      //  uint carbonCredits;

    }
    
    struct Order {
        uint orderId;
        uint credit;
        uint price;
        bool isSell;  // check order
        address seller;
    }
    
    mapping(address => User) private usersMapping;
    mapping (address => bool) public isCompaniesAddMapping;
    mapping (address => uint) public totalCreditMapping;
   // mapping (address => Order[]) public orders;
    mapping (address => uint) public creditToSellMapping;       // Create order-> store credit
    mapping (address => uint []) public orderStructIdMapping;    
    mapping (uint => Order) public orderStructMapping;

    //uint public availableCredit;
    uint public orderCount;
    address public daoAddress;
  
    function setUser(string memory _name,string memory _userName , string memory _email, string memory _companyName, string memory _country, string memory _companyProfileImage) public {
        //  Check if the company is already registered
        require(!isCompaniesAddMapping[msg.sender], "Company is already registered");
        usersMapping[msg.sender] = User(_name,_userName,_email, _companyName, _country,_companyProfileImage);
        // Register the company
        isCompaniesAddMapping[msg.sender] = true;
    }
    
    function getUser(address _address) public view returns ( User memory) {
            return usersMapping[_address];
            //return User Data
    }

    function getUserOrders(address _user) public view returns(uint[] memory) {
              return orderStructIdMapping[_user];
    } 

    function setDaoAddress(address _address) public onlyOwner {
            daoAddress = _address;
    }

    function issueCredit(address _address, uint _credits) external {
        // Check if the sender is a registered company
        require(msg.sender==daoAddress,"Only DAO address can call this function");          //Dao Address
        require(isCompaniesAddMapping[_address], "Company is not registered");
        // store the company's total credit
        totalCreditMapping[_address] += _credits;
    }

    function createOrder(uint _sellCredit,uint _price,address _address) public {
        require(_sellCredit<=totalCreditMapping[msg.sender],"You don't have much credit available");

        orderCount++;
        orderStructMapping[orderCount]=Order(orderCount,_sellCredit,_price,false,_address);
        orderStructIdMapping[msg.sender].push(orderCount);

        totalCreditMapping[msg.sender] -=_sellCredit;
        creditToSellMapping[msg.sender] +=_sellCredit;
    }

    function buyCredit(uint _orderId) public payable  
    {
        require(orderCount >= _orderId,"Order does not exist");
        require(!orderStructMapping[_orderId].isSell, "Order has been filled");
        require(msg.sender != orderStructMapping[_orderId].seller, "Seller cannot buy their own credit");
        require(msg.value == (orderStructMapping[_orderId].credit * orderStructMapping[_orderId].price), "Not enough amount");
        totalCreditMapping[msg.sender] += orderStructMapping[_orderId].credit;
        creditToSellMapping[orderStructMapping[_orderId].seller] -= orderStructMapping[_orderId].credit;
        orderStructMapping[_orderId].isSell = true;
        uint totalPrice = orderStructMapping[_orderId].credit * orderStructMapping[_orderId].price;
        payable(orderStructMapping[_orderId].seller).transfer(totalPrice);
    }

    function withdrawFromContract(uint _amount) public payable onlyOwner {
    require(address(this).balance >= _amount, "Insufficient contract balance");
    payable(msg.sender).transfer(_amount);
    }
    
}
