// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftTest is Test {

    MoodNft public moodNft;
    DeployMoodNft public deployer;

    address user = makeAddr("user");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewSvgURI() external view {
        string memory happySvg = vm.readFile("./img/happy.svg");
        string memory actualHappySvg = deployer.svgToImgURI(happySvg);

        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory actualSadSvg = deployer.svgToImgURI(sadSvg);


        string memory expectedHappySvg = moodNft.getHappySVGURI();
        string memory expectedSadSvg = moodNft.getSadSVGURI();

        assert(keccak256(abi.encodePacked(actualHappySvg)) == keccak256(abi.encodePacked(expectedHappySvg)));
        assert(keccak256(abi.encodePacked(actualSadSvg)) == keccak256(abi.encodePacked(expectedSadSvg)));
    }

    function testMintNft() external {
        vm.prank(user);
        moodNft.mintNft();

        // console.log(moodNft.tokenURI(0));
    }

}