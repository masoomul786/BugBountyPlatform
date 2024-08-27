# Bug Bounty Platform Contract

The `BugBountyPlatform` smart contract is an implementation of a bug bounty platform on the Ethereum blockchain. It enables organizations to post bounties, allows researchers to submit vulnerability reports, and facilitates the claiming of rewards once the reports are resolved.

## Table of Contents

1. [Overview](#overview)
2. [Contract Structure](#contract-structure)
3. [Functions](#functions)
4. [Events](#events)
5. [Deployment](#deployment)
6. [Usage](#usage)
7. [Testing](#testing)
8. [Security Considerations](#security-considerations)
9. [License](#license)

## Overview

The `BugBountyPlatform` contract provides a way for organizations to offer rewards for discovering vulnerabilities. Researchers can submit reports for these bounties, which organizations can then review and resolve. Upon resolution, researchers can claim their rewards. This system helps streamline the bug bounty process and ensures proper tracking of bounties and reports.

## Contract Structure

### Structs

- **Bounty**: Represents a bounty posted by an organization.
  - `id`: Unique identifier for the bounty.
  - `organization`: Address of the organization that posted the bounty.
  - `reward`: Amount of ETH offered as a reward.
  - `description`: Description of the bounty.
  - `isActive`: Indicates if the bounty is still active.

- **Report**: Represents a vulnerability report submitted by a researcher.
  - `bountyId`: ID of the related bounty.
  - `researcher`: Address of the researcher who submitted the report.
  - `reportDetails`: Details of the vulnerability report.
  - `isResolved`: Indicates if the report has been resolved by the organization.
  - `isPaid`: Indicates if the reward has been paid to the researcher.

### State Variables

- `nextBountyId`: Counter for generating unique bounty IDs.
- `nextReportId`: Counter for generating unique report IDs.
- `bounties`: Mapping from bounty ID to `Bounty` struct.
- `reports`: Mapping from report ID to `Report` struct.
- `researcherReports`: Mapping from researcher address to list of report IDs.

## Functions

### `postBounty(uint256 reward, string calldata description)`

Allows organizations to post a new bounty. The bounty becomes active immediately.

- **Parameters**:
  - `reward`: The amount of ETH offered as a reward.
  - `description`: A brief description of the bounty.

### `submitReport(uint256 bountyId, string calldata reportDetails)`

Allows researchers to submit a report for an active bounty.

- **Parameters**:
  - `bountyId`: The ID of the bounty for which the report is being submitted.
  - `reportDetails`: Details of the vulnerability report.

### `resolveReport(uint256 reportId)`

Allows the bounty organization to mark a report as resolved.

- **Parameters**:
  - `reportId`: The ID of the report to be resolved.

### `claimReward(uint256 reportId)`

Allows researchers to claim the reward once their report is resolved.

- **Parameters**:
  - `reportId`: The ID of the report for which the reward is being claimed.

### `withdraw()`

Allows the contract owner to withdraw any funds held in the contract.

## Events

- **BountyPosted(uint256 bountyId, address organization, uint256 reward, string description)**: Emitted when a new bounty is posted.

- **ReportSubmitted(uint256 reportId, uint256 bountyId, address researcher, string reportDetails)**: Emitted when a new report is submitted.

- **ReportResolved(uint256 reportId)**: Emitted when a report is resolved by the bounty organization.

- **RewardClaimed(uint256 reportId, uint256 bountyId, address researcher, uint256 reward)**: Emitted when a researcher claims their reward.

## Deployment

To deploy the `BugBountyPlatform` contract, follow these steps:

1. **Set Up Your Development Environment**:
   - Use a development environment such as [Hardhat](https://hardhat.org/) or [Truffle](https://www.trufflesuite.com/truffle).

2. **Write a Deployment Script**:
   - Example deployment script using Hardhat:

     ```javascript
     const { ethers } = require("hardhat");

     async function main() {
         const [deployer] = await ethers.getSigners();
         console.log("Deploying contracts with the account:", deployer.address);

         const BugBountyPlatform = await ethers.getContractFactory("BugBountyPlatform");
         const contract = await BugBountyPlatform.deploy();
         await contract.deployed();

         console.log("BugBountyPlatform deployed to:", contract.address);
     }

     main().catch((error) => {
         console.error(error);
         process.exitCode = 1;
     });
     ```

3. **Deploy the Contract**:
   - Run the deployment script using Hardhat:
     ```bash
     npx hardhat run scripts/deploy.js --network <network>
     ```

## Usage

1. **Post a Bounty**:
   - Call the `postBounty` function with the reward amount and description.

2. **Submit a Report**:
   - Call the `submitReport` function with the bounty ID and report details.

3. **Resolve a Report**:
   - Call the `resolveReport` function (must be the bounty organization).

4. **Claim Reward**:
   - Call the `claimReward` function (must be the researcher).

5. **Withdraw Funds**:
   - The contract owner can call the `withdraw` function to withdraw ETH from the contract.

## Testing

To test the contract, use the testing framework provided by your development environment (e.g., Hardhat or Truffle). Write test cases to cover all functions and edge cases.

## Security Considerations

- Ensure that only authorized users can call restricted functions (e.g., `resolveReport` should only be callable by the bounty organization).
- Consider adding additional security measures and checks as needed, such as access controls and reentrancy guards.

## License

This contract is licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Deployment
0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8

![image](https://github.com/user-attachments/assets/f2051d5c-4ec0-4969-98a1-e50ef518f2e1)

