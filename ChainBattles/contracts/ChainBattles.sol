// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint private nonce;

    struct Stats {
        uint256 hp;
        uint256 strength;
        uint256 speed;
        uint256 level;
    }

    mapping(uint256 => Stats) public tokenIdToStats;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    /**
     * @dev Generates a base64 encoded svg image string.
     * @param _tokenId the token id
     * @return string the base64 encoded svg image string
     */
    function generateCharacter(
        uint256 _tokenId
    ) public view returns (string memory) {
        Stats memory stats = getStats(_tokenId);
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="20" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="40" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Level: ",
            stats.level.toString(),
            "</text>",
            '<text x="50%" y="60" class="base" dominant-baseline="middle" text-anchor="middle">',
            "HP: ",
            (stats.hp).toString(),
            "</text>",
            '<text x="50%" y="80" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Strength: ",
            (stats.strength).toString(),
            "</text>",
            '<text x="50%" y="100" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Speed: ",
            (stats.speed).toString(),
            "</text>",
            "</svg>"
        );

        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    /**
     * @dev Retrives the current stats for a specified token id.
     * @param _tokenId the token id
     * @return string the levels string
     */
    function getStats(uint256 _tokenId) public view returns (Stats memory) {
        return tokenIdToStats[_tokenId];
    }

    /**
     * @dev Retrieves the base64 encoded token URI string for a specified token id.
     * @param _tokenId the token id
     * @return string the base64 encoded data token URI string
     */
    function getTokenURI(uint256 _tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            _tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(_tokenId),
            '"',
            "}"
        );

        return
            string(
                abi.encodePacked(
                    abi.encodePacked(
                        "data:application/json;base64,",
                        Base64.encode(dataURI)
                    )
                )
            );
    }

    /**
     * @dev Allows for minting an NFT.
     */
    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);

        //implement base random stats
        Stats memory stats = Stats(100, random(), random(), 1);

        tokenIdToStats[newItemId] = stats;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    /**
     * @dev Allows for training the token.
     */
    function train(uint256 _tokenId) public {
        require(_exists(_tokenId), "Please use an existing token.");
        require(
            ownerOf(_tokenId) == msg.sender,
            "You must own this token to train it."
        );
        Stats memory stats = tokenIdToStats[_tokenId];

        //randomize values to other stats
        stats.level++;
        stats.hp += 10;
        stats.speed += random();
        stats.strength += random();

        tokenIdToStats[_tokenId] = stats;
        _setTokenURI(_tokenId, getTokenURI(_tokenId));
    }

    /**
     * @dev Retrieves a pseudo random number between 1 and 10.
     * @return uint256 the random number
     */
    function random() internal returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, nonce++)
                )
            ) % 10;
    }
}
