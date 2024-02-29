// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PrizeDistribution.sol";

contract PrizeDistributionFactory is Ownable {
    // Array to store addresses of deployed PrizeDistribution contracts
    address[] public prizeDistributionContracts;

    // Event to track deployment of new PrizeDistribution contracts
    event PrizeDistributionDeployed(address indexed prizeDistribution, address indexed owner);

    // Function to deploy a new instance of PrizeDistribution contract
    function deployPrizeDistribution(
        address _vrfCoordinator,
        address _linkToken,
        bytes32 _keyHash,
        uint256 _fee,
        address _tokenContract
    ) external {
        PrizeDistribution newPrizeDistribution = new PrizeDistribution(
            _vrfCoordinator,
            _linkToken,
            _keyHash,
            _fee,
            _tokenContract,
            msg.sender
        );

        prizeDistributionContracts.push(address(newPrizeDistribution));

        emit PrizeDistributionDeployed(address(newPrizeDistribution), msg.sender);
    }

    // Function to get the count of deployed PrizeDistribution contracts
    function getPrizeDistributionCount() external view returns (uint256) {
        return prizeDistributionContracts.length;
    }
}
