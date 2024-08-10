// SPDX-License-Identifier: {{license}}
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract {{contractName}} is Ownable {
    using Counters for Counters.Counter;
    using EnumerableSet for EnumerableSet.AddressSet;

    IERC20 public governanceToken;
    Counters.Counter private proposalCounter;

    uint256 public constant VOTING_PERIOD = 1 weeks;
    uint256 public constant MINIMUM_QUORUM = 1000 * 10**18; // Minimum number of votes required for a proposal to be valid

    enum ProposalState { Active, Defeated, Succeeded, Executed }

    struct Proposal {
        uint256 id;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 startTime;
        ProposalState state;
        address proposer;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => EnumerableSet.AddressSet) private proposalVoters;
    mapping(address => uint256) public lockedTokens;

    event ProposalCreated(uint256 indexed proposalId, string description, address indexed proposer);
    event VoteCast(address indexed voter, uint256 indexed proposalId, bool support);
    event ProposalExecuted(uint256 indexed proposalId);

    constructor(address _governanceToken) {
        governanceToken = IERC20(_governanceToken);
    }

    function createProposal(string memory _description) external {
        proposalCounter.increment();
        uint256 proposalId = proposalCounter.current();

        proposals[proposalId] = Proposal({
            id: proposalId,
            description: _description,
            votesFor: 0,
            votesAgainst: 0,
            startTime: block.timestamp,
            state: ProposalState.Active,
            proposer: msg.sender
        });

        emit ProposalCreated(proposalId, _description, msg.sender);
    }

    function vote(uint256 _proposalId, bool _support) external {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.state == ProposalState.Active, "Proposal is not active");
        require(block.timestamp < proposal.startTime + VOTING_PERIOD, "Voting period has ended");
        require(!proposalVoters[_proposalId].contains(msg.sender), "Already voted");

        uint256 voterBalance = governanceToken.balanceOf(msg.sender);
        require(voterBalance > 0, "No governance tokens");

        proposalVoters[_proposalId].add(msg.sender);
        lockedTokens[msg.sender] += voterBalance;

        if (_support) {
            proposal.votesFor += voterBalance;
        } else {
            proposal.votesAgainst += voterBalance;
        }

        emit VoteCast(msg.sender, _proposalId, _support);
    }

    function executeProposal(uint256 _proposalId) external onlyOwner {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.state == ProposalState.Active, "Proposal is not active");
        require(block.timestamp >= proposal.startTime + VOTING_PERIOD, "Voting period has not ended");

        if (proposal.votesFor + proposal.votesAgainst >= MINIMUM_QUORUM) {
            if (proposal.votesFor > proposal.votesAgainst) {
                proposal.state = ProposalState.Succeeded;
                // Execute proposal action here
                emit ProposalExecuted(_proposalId);
            } else {
                proposal.state = ProposalState.Defeated;
            }
        } else {
            proposal.state = ProposalState.Defeated;
        }

        for (uint256 i = 0; i < proposalVoters[_proposalId].length(); i++) {
            address voter = proposalVoters[_proposalId].at(i);
            lockedTokens[voter] = 0;
        }
    }

    function withdrawTokens(uint256 _amount) external {
        require(lockedTokens[msg.sender] >= _amount, "Insufficient locked tokens");
        lockedTokens[msg.sender] -= _amount;
        governanceToken.transfer(msg.sender, _amount);
    }
}

