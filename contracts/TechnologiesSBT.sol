// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract TechnologiesSBT is ERC1155Upgradeable, AccessControlUpgradeable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    mapping(uint256 => string) private _tokenURIs;

    function initialize() public initializer {
        super.__ERC1155_init("ipfs://f0{id}");
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(BURNER_ROLE, msg.sender);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        if (bytes(_tokenURIs[tokenId]).length == 0) {
            //specific value is not set
            string memory hexstringtokenID;
            hexstringtokenID = uint2hexstr(tokenId);

            return string(abi.encodePacked("ipfs://f0", hexstringtokenID));
        }
        return _tokenURIs[tokenId];
    }

    function setTokenUri(
        uint256 tokenId,
        string memory tokenURI
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _tokenURIs[tokenId] = tokenURI;
    }

    function mint(address to, uint256 id) public virtual onlyRole(MINTER_ROLE) {
        _mint(to, id, 1, "New NFT minted");
    }

    function _beforeTokenTransfer(
        address,
        address from,
        address to,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) internal pure override {
        require(
            from == address(0) || to == address(0),
            "Soulbound token: Cannot be transferred."
        );
    }

    function uint2hexstr(uint256 i) public pure returns (string memory) {
        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0) {
            length++;
            j = j >> 4;
        }
        uint mask = 15;
        bytes memory bstr = new bytes(length);
        uint k = length;
        while (i != 0) {
            uint curr = (i & mask);
            bstr[--k] = curr > 9
                ? bytes1(uint8(55 + curr))
                : bytes1(uint8(48 + curr)); // 55 = 65 - 10
            i = i >> 4;
        }
        return string(bstr);
    }

    // EIP-165 support
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(AccessControlUpgradeable, ERC1155Upgradeable)
        returns (bool)
    {
        return
            AccessControlUpgradeable.supportsInterface(interfaceId) ||
            ERC1155Upgradeable.supportsInterface(interfaceId);
    }
}
