// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Lock is ERC20{
    uint256 private constant i_TOTAL_SUPPLY = 100000; //100000 tokens total supply
    uint256 private constant i_LOCK_AMOUNT = 24000;   //24000 tokens to be locked 
    uint256 private constant i_LOCK_TIME = 2592000; // unix time for 30-day months
    uint256 private constant i_COINS_UNLOCK_VALUE = 100; //100 coins to be unlocked every month
    uint256 private s_lastTokenUnlockTime;
    address private owner;

    // Track the burned tokens
    uint256 public totalBurned;

    // Track the minted tokens
    uint256 public totalMinted;

    // Track the locked coins
    uint256 public lockedCoins;

    modifier onlyOwner() {
    require(msg.sender == owner);
    _;
}

    constructor() ERC20("VDOIT TOKEN", "VDOIT"){
        s_lastTokenUnlockTime = block.timestamp;
        _mint(msg.sender, i_TOTAL_SUPPLY - i_LOCK_AMOUNT);
        lockedCoins = i_LOCK_AMOUNT ;
        owner = msg.sender;
    }

    // Burn tokens
    function burn(uint256 amount) public onlyOwner {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
        totalBurned += amount;
    }

    // Mint new tokens
    function mint(address account, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= i_TOTAL_SUPPLY, "Exceeds total supply");
        _mint(account, amount);
        totalMinted += amount;
    }

    // Unlock coins function to be called by Chainlink Keeper
    function unlockCoins() external {
        require(totalSupply() + i_COINS_UNLOCK_VALUE <= i_TOTAL_SUPPLY, "Exceeds total supply");
        uint currentTimeStamp = block.timestamp;
        require(currentTimeStamp - s_lastTokenUnlockTime >= i_LOCK_TIME, "Time Constraint not fulfilled");
        _mint(owner,i_COINS_UNLOCK_VALUE);
        s_lastTokenUnlockTime = currentTimeStamp;
    }
}