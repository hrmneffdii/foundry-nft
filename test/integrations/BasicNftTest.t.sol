// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    BasicNft public basicNft;

    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    address public USER = makeAddr("USER");
    
    function setUp() public {
        DeployBasicNft deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testName() external view{
        string memory actualName = "Dogie";
        string memory expectedName = basicNft.name();

        assert(keccak256(abi.encodePacked(actualName)) == keccak256(abi.encodePacked(expectedName)));
    }

    function testSymbol() external view{
        string memory actualSymbol = "DOG";
        string memory expectedSymbol = basicNft.symbol();

        assert(keccak256(abi.encodePacked(actualSymbol)) == keccak256(abi.encodePacked(expectedSymbol)));
    }

    function testCanMintAndHaveABalance() external {
        vm.prank(USER);

        basicNft.mintNft(PUG_URI);

        assert(basicNft.balanceOf(USER) == 1);
        assert(basicNft.ownerOf(0) == USER);
        assert(keccak256(abi.encodePacked(PUG_URI)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }

    function testCountOfTokenCounter() external {
        vm.prank(USER);

        basicNft.mintNft(PUG_URI);
        assert(basicNft.tokenCounter() == 1);
    }
}