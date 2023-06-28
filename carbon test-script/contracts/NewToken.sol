// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NewToken is ERC20, Ownable {
    uint256 tokenPrice; // 1 token = 1000 Ether  wei =1000000000000000000000

    constructor(uint _supply, uint _tokenPrice) ERC20("CarboEx", "CX") {
        tokenPrice = _tokenPrice;
        _mint(msg.sender, _supply);
    }

    function mint(uint _supply) public onlyOwner {
        _mint(msg.sender, _supply);
    }

    function withdrawTokenFromContract(
        uint _amount,
        address _tokenAddress
    ) public payable onlyOwner {
        IERC20 _token = IERC20(_tokenAddress);
        require(
            _token.balanceOf(address(this)) >= _amount,
            "Insufficient token balance in the contract"
        );
        _token.transfer(msg.sender, _amount);
    }

    // set token price for onlyOwner
    function setTokenPrice(uint _tokenPrice) public onlyOwner {
        tokenPrice = _tokenPrice;
    }

    function getTokenPrice() public view returns (uint) {
        return tokenPrice;
    }

    function tokenTransfer(
        address _contractAddress,
        uint _amount
    ) public payable onlyOwner {
        IERC20 _token = IERC20(address(this));
        _token.transferFrom(msg.sender, _contractAddress, _amount);
    }

    function withdrawFromContract(uint _amount) public payable onlyOwner {
        require(
            address(this).balance >= _amount,
            "Insufficient contract balance"
        );
        payable(msg.sender).transfer(_amount);
    }
}
