// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BugBountyPlatform {

    // Struct to represent a bounty
    struct Bounty {
        uint256 id;
        address payable organization;
        uint256 reward;
        string description;
        bool isActive;
    }

    // Struct to represent a vulnerability report
    struct Report {
        uint256 bountyId;
        address researcher;
        string reportDetails;
        bool isResolved;
        bool isPaid;
    }

    // State variables
    uint256 public nextBountyId;
    uint256 public nextReportId;
    mapping(uint256 => Bounty) public bounties;
    mapping(uint256 => Report) public reports;
    mapping(address => uint256[]) public researcherReports;

    // Events
    event BountyPosted(uint256 bountyId, address organization, uint256 reward, string description);
    event ReportSubmitted(uint256 reportId, uint256 bountyId, address researcher, string reportDetails);
    event ReportResolved(uint256 reportId);
    event RewardClaimed(uint256 reportId, uint256 bountyId, address researcher, uint256 reward);

    // Post a new bounty
    function postBounty(uint256 reward, string calldata description) external {
        require(reward > 0, "Reward must be greater than zero");
        
        bounties[nextBountyId] = Bounty({
            id: nextBountyId,
            organization: payable(msg.sender),
            reward: reward,
            description: description,
            isActive: true
        });

        emit BountyPosted(nextBountyId, msg.sender, reward, description);
        nextBountyId++;
    }

    // Submit a vulnerability report
    function submitReport(uint256 bountyId, string calldata reportDetails) external {
        Bounty storage bounty = bounties[bountyId];
        require(bounty.isActive, "Bounty is not active");
        
        reports[nextReportId] = Report({
            bountyId: bountyId,
            researcher: msg.sender,
            reportDetails: reportDetails,
            isResolved: false,
            isPaid: false
        });

        researcherReports[msg.sender].push(nextReportId);
        
        emit ReportSubmitted(nextReportId, bountyId, msg.sender, reportDetails);
        nextReportId++;
    }

    // Resolve a report (only the bounty organization can resolve)
    function resolveReport(uint256 reportId) external {
        Report storage report = reports[reportId];
        Bounty storage bounty = bounties[report.bountyId];
        
        require(bounty.organization == msg.sender, "Only the bounty organization can resolve the report");
        require(!report.isResolved, "Report is already resolved");
        
        report.isResolved = true;
        
        emit ReportResolved(reportId);
    }

    // Claim the reward (only the researcher can claim after report is resolved)
    function claimReward(uint256 reportId) external {
        Report storage report = reports[reportId];
        Bounty storage bounty = bounties[report.bountyId];
        
        require(report.researcher == msg.sender, "Only the researcher can claim the reward");
        require(report.isResolved, "Report must be resolved before claiming reward");
        require(!report.isPaid, "Reward has already been paid");
        require(bounty.isActive, "Bounty is not active");
        
        report.isPaid = true;
        bounty.isActive = false; // Deactivate bounty once it is claimed
        
        payable(msg.sender).transfer(bounty.reward);

        emit RewardClaimed(reportId, bounty.id, msg.sender, bounty.reward);
    }

    // Helper function to withdraw funds (for the contract owner)
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }

    // Fallback function to receive ETH
    receive() external payable {}
}
