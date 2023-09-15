// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";


contract TreeFarm is ChainlinkClient, ERC20{

    // Chainlink variables
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    constructor(
        address _oracle,
        bytes32 _jobId,
        uint256 _fee,
        address _link,
        address _calculationContract
    ) ERC20("HYphi","HYphiS") {
        setChainlinkToken(_link);
        oracle = _oracle;
        jobId = _jobId;
        fee = _fee; // Fee in LINK (1 LINK = 10^18 wei)


        calculation = Calculation(_calculationContract);
        _owner = msg.sender;

    }

    function createTree() public {
        // Request data from the Chainlink oracle
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );
        //this pard need some update
        add("get", "https://your-api-endpoint.com"); // Replace with your API endpoint
        req.add("path", "treesCreated"); // Replace with the JSON path to the data you want
        req.add("copyPath", "treesCreated"); // Copy the data to the top-level response

        // Send the request
        sendChainlinkRequestTo(oracle, req, fee);
    }

    // Callback function to receive the response from the oracle
    function fulfill(bytes32 _requestId, uint256 _treesCreated) public recordChainlinkFulfillment(_requestId) {
        // Store the received data in the contract
        _plantedTrees = _treesCreated;
    }

    // Get function to retrieve the value of treesCreated
    function getTreesCreated() external view returns (uint256) {
        return _plantedTrees;
    }

        /*  total trees planted so far
    this number is updated with number of tokens minted */
    uint internal _plantedTrees;
    uint internal _totalMinted;
    address immutable internal _owner;

    Calculation internal calculation;

    /*
    @dev allows users to mint tokens in exchange of some ether they pay
    Calculation in such contracts is often sourced out of external contracts
    */

    function mint() external payable {
        uint _plantedSoFar = _plantedTrees;
        createTree();
        uint _plantedUpdated = _plantedTrees;
        uint new_added = _plantedSoFar - _plantedSoFar;
        uint tokens_to_add = new_added*10000000;
        _mint(_owner, tokens_to_add);
        _totalMinted = _totalMinted + tokens_to_add;
    }

    function checkTotalPlantedTrees() external view returns(uint256) {
        return _plantedTrees;
    }

    function updateCalculationContract(address _addr) external onlyOwner {
        calculation = Calculation(_addr);
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
