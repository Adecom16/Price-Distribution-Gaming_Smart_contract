// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PrizeDistribution is VRFConsumerBase, Ownable {
    // Chainlink VRF variables
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    
    // ERC20 token contract
    IERC20 public tokenContract;

    // Participant structure 
    struct Participant {
        uint256 entries;
    }

    // Mapping of participant addresses to their participation details
    mapping(address => Participant) public participants;

    // Prize distribution event
    event PrizeDistributionEvent(address[] winners, uint256[] rewards);

    // Constructor
  constructor(address _vrfCoordinator, address _linkToken, bytes32 _keyHash, uint256 _fee, address _tokenContract, address initialOwner) 
    VRFConsumerBase(_vrfCoordinator, _linkToken)
    Ownable(initialOwner)
{
    keyHash = _keyHash;
    fee = _fee;
    tokenContract = IERC20(_tokenContract);
}


    // Register as a participant
    function registerParticipant() external {
        require(participants[msg.sender].entries == 0, "Participant already registered");
        participants[msg.sender].entries = 0;
    }

    // Participate in the activity and earn entries
    function participate(uint256 _entries) external {
        require(_entries > 0, "Invalid number of entries");
        participants[msg.sender].entries += _entries;
    }

    // Trigger prize distribution event
    function triggerPrizeDistribution() external onlyOwner {
        // Call Chainlink VRF to generate random number
        requestRandomness(keyHash, fee);
    }

    // Callback function called by Chainlink VRF with random number result
    function fulfillRandomness(bytes32 _requestId, uint256 _randomness) internal override {
        randomResult = _randomness;
        distributePrizes();
    }

    // Distribute prizes to winners
    function distributePrizes() internal {
        // Determine winners based on random number
        address[] memory winners;
        uint256[] memory rewards;

        // Logic to select winners and calculate rewards based on randomResult and participant entries
        // For demonstration purposes, we randomly select winners and distribute equal rewards
        for (uint256 i = 0; i < 3; i++) {
            address winner = address(uint160(uint256(keccak256(abi.encode(randomResult, i)))));
            uint256 reward = 1000; // Example reward amount
            winners[i] = winner;
            rewards[i] = reward;
        }

        // Emit prize distribution event
        emit PrizeDistributionEvent(winners, rewards);

        // Distribute tokens to winners
        distributeTokens(winners, rewards);
    }

    // Distribute ERC20 tokens to winners
    function distributeTokens(address[] memory _winners, uint256[] memory _rewards) internal {
        require(_winners.length == _rewards.length, "Invalid input lengths");

        for (uint256 i = 0; i < _winners.length; i++) {
            require(tokenContract.transfer(_winners[i], _rewards[i]), "Token transfer failed");
        }
    }
}
