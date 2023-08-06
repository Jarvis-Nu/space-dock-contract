// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";

/// @title VentureFactory
/// @author @okhaimie-dev
/// @notice This contract is used to create a venture.
contract SpaceDock {
    using Counters for Counters.Counter;
    Counters.Counter private _ventureIdCounter;

    string public ventureBaseURI;

    /**
     * @dev Struct to store details about each venture.
     */
    struct Venture {
        string ipfsHash;
        string name;
        address creator;
        uint256 createdAt;
    }

    /**
     * @dev Mapping to associate a venture ID with its Venture struct.
     */
    mapping(uint256 => Venture) public ventures;

    /**
     * @dev Event emitted when a new venture is created.
     * @param ventureId The ID of the venture.
     * @param ipfsHash The IPFS hash associated with the venture.
     * @param createdAt The timestamp of when the venture was created.
     */
    event VentureCreated(uint256 indexed ventureId, string ipfsHash, string name, address indexed creator, uint256 createdAt);

    /**
     * @dev Create a new venture.
     * @param ipfsHash The IPFS hash associated with the venture.
     * @param name The name of the Venture.
     * @notice The IPFS hash and name cannot be empty strings.
     */
    function createVenture(string memory ipfsHash, string memory name) public {
        require(bytes(ipfsHash).length > 0, "IPFS hash cannot be empty");
        require(bytes(name).length > 0, "Project name cannot be empty");

        _ventureIdCounter.increment();
        uint256 ventureId = _ventureIdCounter.current();

        // Save project details
        ventures[ventureId] = Venture({
            ipfsHash: ipfsHash,
            name: name,
            creator: msg.sender,
            createdAt: block.timestamp
        });

        emit VentureCreated(ventureId, ipfsHash, name, msg.sender, block.timestamp);
    }

    /**
     * @dev Retrieve the Base URI for a specific venture.
     * @param ventureId The ID of the venture.
     * @return The Base URI for the venture's metadata.
     * @notice The venture base URI must be set before calling this function.
     */
    function ventureURI(uint256 ventureId) public view returns (string memory) {
        require(ventureId > 0 && ventureId <= _ventureIdCounter.current(), "Invalid venture ID");
        return string(abi.encodePacked(ventureBaseURI, ventures[ventureId].ipfsHash));
    }

}
