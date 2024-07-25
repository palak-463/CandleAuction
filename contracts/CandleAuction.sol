// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CandleAuction {
    address public owner;
    uint256 public auctionEndTime;
    uint256 public highestBid;
    address public highestBidder;
    bool public auctionEnded;

    event AuctionStarted(uint256 endTime);
    event NewBid(address indexed bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function startAuction(uint256 duration) public {
        require(msg.sender == owner, "Only owner can start the auction");
        auctionEndTime = block.timestamp + duration;
        auctionEnded = false;
        emit AuctionStarted(auctionEndTime);
    }

    function bid() public payable {
        require(block.timestamp < auctionEndTime, "Auction has ended");
        require(msg.value > highestBid, "Bid is not high enough");
        require(!auctionEnded, "Auction already ended");

        if (highestBidder != address(0)) {
            payable(highestBidder).transfer(highestBid); // Refund the previous highest bidder
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit NewBid(msg.sender, msg.value);
    }

    function endAuction() public {
        require(msg.sender == owner, "Only owner can end the auction");
        require(block.timestamp >= auctionEndTime, "Auction not yet ended");
        require(!auctionEnded, "Auction already ended");

        auctionEnded = true;
        payable(owner).transfer(highestBid); // Transfer the highest bid to the owner
        emit AuctionEnded(highestBidder, highestBid);
    }
}
