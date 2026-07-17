# TimeVault Smart Contract

A secure, time-locked Ethereum crowdfunding and donation vault built in Solidity. `TimeVault` allows users to fund the contract with Ether (enforcing a minimum USD value using Chainlink price feeds) while guaranteeing that the contract owner cannot withdraw the accumulated funds until a strict 7-day lock period has passed.

## Features

- **Time-Locked Withdrawals:** Uses `block.timestamp` combined with an `immutable` deployment marker to securely lock all funds for exactly 7 days from contract creation.
- **Chainlink Price Feed Integration:** Fetches real-time ETH/USD price data to dynamically calculate deposit values.
- **Minimum Donation Limit:** Enforces a minimum deposit requirement equivalent to $10 USD to prevent spam.
- **Gas Optimized:** Utilizes `immutable` state variables for the owner and the initialization timestamp to drastically reduce EVM execution costs.
- **Fallback Protection:** Equipped with `receive()` and `fallback()` functions to safely handle direct ETH transfers.

## How It Works

### 1. Funding
Users call the `fund()` function (or send ETH directly to the contract address). The contract calls the Chainlink Oracle to check the current price of ETH, converts the incoming `msg.value` to its USD equivalent, and ensures it is greater than or equal to \$10 USD. If it passes, the contributor's address and amount are logged.

### 2. The Lock Mechanism
Upon deployment, the contract records the deployment time:
```solidity
startTime = block.timestamp;

3. Withdrawal
Once the 7-day timer expires, the contract owner can invoke withdraw(). This resets all funder tracking metrics to zero and securely transfers the entire vault balance back to the owner's address.


License
This project is licensed under the MIT License.


