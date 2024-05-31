// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721{
    error ERC721Metadata__URI_QueryFor_NonExistentToken();
    error MoodNft__CantFlipMoodIfNotOwner();

    enum NFTState {
        HAPPY,
        SAD
    }

    uint256 private s_tokenCounter;
    string private s_sadSvgImageURI;
    string private s_happySvgImageURI;
    mapping(uint256 => NFTState) private s_tokenIdToState;

    event CreatedNFT(uint256 indexed tokenId);
    
    constructor (string memory _sadSvgImageURI, string memory _happySvgImageURI) ERC721("MoodNft", "MN") {
        s_sadSvgImageURI = _sadSvgImageURI;
        s_happySvgImageURI = _happySvgImageURI;
        s_tokenCounter = 0;

        emit CreatedNFT(s_tokenCounter);
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToState[s_tokenCounter] = NFTState.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        if(msg.sender != ownerOf(tokenId) && getApproved(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToState[tokenId] == NFTState.HAPPY) {
            s_tokenIdToState[tokenId] = NFTState.SAD;
        } else {
            s_tokenIdToState[tokenId] = NFTState.HAPPY;
        }

    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
         if (ownerOf(tokenId) == address(0)) {
            revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        }
        string memory imageURI = s_happySvgImageURI;

        if (s_tokenIdToState[tokenId] == NFTState.SAD) {
            imageURI = s_sadSvgImageURI;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                        abi.encodePacked(
                            '{"name":"',
                            name(), // You can add whatever name here
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    /** Getter function */

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function getHappySVGURI() public view returns (string memory) {
        return s_happySvgImageURI;
    }

    function getSadSVGURI() public view returns (string memory) {
        return s_sadSvgImageURI;
    }
}