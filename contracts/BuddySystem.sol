// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract BuddySystem {
    /**
     * Buddy Mapping.
     */
    mapping(address => address) public buddies;

    /**
     * On update buddy event.
     */
    event onUpdateBuddy(address indexed player, address indexed buddy);

    /**
     * Reject payments.
     */
    receive() payable external {
        require(false, "Don't send funds to this contract");
    }

    /**
     * Update buddy.
     */
    function updateBuddy(address buddy) external {
        buddies[msg.sender] = buddy;
        emit onUpdateBuddy(msg.sender, buddy);
    }

    /**
     * Buddy of.
     */
    function buddyOf(address player) public view returns (address) {
        return buddies[player];
    }

    /**
     * My buddy.
     */
    function myBuddy() external view returns(address) {
        return buddyOf(msg.sender);
    }
}
