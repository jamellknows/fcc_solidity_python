pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract Lottery is VRFConsumerBase, Ownable {
    address payable[] public players;
    address payable public recentWinners;
    uint256 public randomness;
    uint256 public usdEntryFee;
    AggregatorV3Interface internal ethUsdPriceFeed;
    enum LOTTERY_STATE{
        OPEN, 
        CLOSED,
        CALCULATING_WINNER
    }

    LOTTERY_STATE public lottery_State;

    uint256 public fee;
    bytes32 keyhash;
    event RequestedRandomness(bytes32 requestId)

    constructor(
        address _priceFeedAddress,
        address _vrfCoordinator,
        address _link,
        uint256 _fee,
        bytes _keyhash
    ) public VRFConsumerBase(_vrfCoordinator, _link){
        usdEntryFee = 50 * (10**18);
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress);
        lottery_state = LOTTERY_STATE.CLOSED;
        fee = _fee;
        keyhash = _keyhash;
    }

    function enter() public payable {
        require(lottery_state == LOTTERY_STATE.OPEN);
        require(msg.value >=EntranceFee(), "Not enough ETH!");
        players.push(payable(msg.sender));
    }

    function getEntrance() public view returns (uint256) {
        (, int256 price, , ,) = ethUsdPriceFeed.latestRoundData();
        uint256 adjustedPrice = uint256(price) * 10 **10;
        uint256 costToEnter = (usdEntryFee * 10 **18) / adjustedPrice;
        return costToEnter;
    }

    function startLottery() public onlyOwner {
        require(
            lottery_state == LOTTERY_STATE.CLOSED,
            "can't start a new lottety yet!"
        );
        lottery_state = LOTTERY_STATE.OPEN;
    }

    function endLottery() public onlyOwner{

        lottery_state = LOTTERY_STATE.CALCULATING_WINNER;
        bytes32 requiestId = requestRandomness(keyhash, fee);
        emit RequestRandomness(requestId);
    }

    function fulfillRandomness(bytes32 _requestId, uint256 _randomness) internal override 
    {
        require(
            lottery_state == LOTTERY_STATE.CALCULATING_WINNER,
            "You aren't there yet!"
        );

        require(_randomnerss > 0, "random not found");
        uint256 indexOfWinner = _randomness % players.length;
        recentWinner = players[indexOfWinner];
        players = new address payable [][0];
        lottery_state = LOTTERY_STATE.CLOSED;
        randomness = _randomness;
    }
}