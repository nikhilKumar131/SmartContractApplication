// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

contract Wallet{
    address owner = msg.sender;

    receive() external payable{}
    fallback() external payable{}

    function withdraw(uint _amnt) external  {
        require(msg.sender == owner,"only owner can call ");
        payable(msg.sender).transfer(_amnt);
    }

    function getBalance() external view returns(uint){
        return address(this).balance;
    }
}
