// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Hyphi001 is ERC20{

    /*  total trees planted so far
    this number is updated with number of tokens minted */
    uint internal _plantedTrees;
    uint internal _totalMinted;
    address immutable internal _owner;

    Calculation internal calculation;

    /*
    basic constructor
    @dev initializes the contract and constructor 
    with name "HYphi" and symbol "HYphiS"
    */

    constructor(address _calculationContract) ERC20("HYphi","HYphiS"){

        //can add a _mint function that mints x amount of hyphi to owner

        //variable initialization such a total supply etc.

        //can change decam values or other functions of token here

        calculation = Calculation(_calculationContract);
        _owner = msg.sender;
    }

    /*
    @dev allows users to mint tokens in exchange of some ether they pay
    Calculation in such contracts is often sourced out of external contracts
    */

    function mint(uint256 _tokens) external payable uintZeroCheck(_tokens) {
        uint _coinsRequired = calculation._calculateCoinsRequired(_tokens);
        require(msg.value >= _coinsRequired, "send the same amount of token as well");
        _mint(msg.sender, _tokens);
        _totalMinted += _totalMinted;
        updateTotalTreesPlanted(_totalMinted);

    }

    function checkTotalPlantedTrees() external view returns(uint256) {
        return _plantedTrees;
    }

    function updateCalculationContract(address _addr) external onlyOwner {
        calculation = Calculation(_addr);
    }

    function updateTotalTreesPlanted(uint _mintedTotal) internal {
        _plantedTrees = _mintedTotal/10000000;
    }



    //modifiers
    modifier uintZeroCheck(uint _val){
        require(_val != 0,"uint value used can't be 0");
        _;
    }

    modifier addressNotZero(address _addr){
        require(_addr != address(0),"address can't be x000..");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner,"only owner can access this function");
        _;
    }

}

/*
UPDATES REQUIRED
safeMath is not used as this is just first basic contract.
*/



contract Calculation{
    
    /*  @func calculates the number of coins needed to mint
    a specific number of tokens.
    This function is kept in external contract, so it could
    be updated later on */

    function _calculateCoinsRequired(uint _tokens) external pure returns(uint){
        //for sake of example we will use a fixed rate.
        //otherwise it will import rates directly from pools
        uint val = _tokens*2;
        return val;

    }

}