# DAO Contract Template

This template provides a basic implementation of a DAO Governance Contract. A DAO (Decentralized Autonomous Organization) Governance Contract allows for decentralized decision-making on the blockchain. It typically includes features like proposal creation, voting mechanisms, and execution of decisions based on the outcome of votes.

## Explanation

**Governance Token**: The contract uses an ERC20 governance token for voting. The address of the token contract is passed during the deployment of the DAO contract.

**Proposal Structure**:

- Each proposal has an ID, description, number of votes for and against, start time, state, and proposer.

**Proposal States**: Proposals can be in one of the following states: Active, Defeated, Succeeded, or Executed.

**createProposal Function**:

- Allows any user to create a proposal by providing a description.

**vote Function**:

- Allows users to vote on active proposals by indicating support or opposition.

- Voters' tokens are locked during the voting period.
execute

**Proposal Function**:

- The contract owner can execute a proposal after the voting period ends.

- If the proposal meets the quorum and has more votes for than against, it is marked as succeeded and executed.

- Otherwise, it is marked as defeated.

**withdrawTokens Function**:

- Allows users to withdraw their locked tokens after the proposal voting period has ended.

## Usage

**Deploy the Contract**: Deploy the contract with the governance token address.

**Create Proposals**: Users can create proposals using the createProposal function.

**Vote on Proposals**: Users can vote on proposals using the vote function.

**Execute Proposals**: The contract owner can execute proposals using the executeProposal function.

**Withdraw Tokens**: Users can withdraw their locked tokens after the voting period using the withdrawTokens function.
