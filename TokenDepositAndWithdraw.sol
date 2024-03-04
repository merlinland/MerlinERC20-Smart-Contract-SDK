// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Interface for the MerlinERC20 standard as required for the interaction with MerlinERC20 tokens.

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

// A contract that allows deposit and withdrawal of specific MerlinERC20 tokens.
contract TokenDepositAndWithdraw {
    address public owner;
    // Mapping from token address to user address to balance for tracking balances of each token for each user.
    mapping(address => mapping(address => uint256)) public tokenBalances;

    // Constructor sets the deployer as the owner of the contract.
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict certain functions to the owner of the contract.
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // Function to deposit a specific amount of an MerlinERC20 token into the contract.
    // The contract must be approved to spend the token beforehand.
    function depositToken(address _token, uint256 _amount) public {
        IERC20 token = IERC20(_token);
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        tokenBalances[_token][msg.sender] += _amount;
    }

    // Function that allows the owner to withdraw a specific amount of an MerlinERC20 token from the contract.
    function withdrawToken(address _token, address _to, uint256 _amount) public onlyOwner {
        require(tokenBalances[_token][address(this)] >= _amount, "Insufficient balance");
        IERC20 token = IERC20(_token);
        require(token.transfer(_to, _amount), "Transfer failed");
        tokenBalances[_token][address(this)] -= _amount;
    }

    // Function to check the balance of a specific token for a user.
    function getBalance(address _token, address _user) public view returns (uint256) {
        return tokenBalances[_token][_user];
    }
}