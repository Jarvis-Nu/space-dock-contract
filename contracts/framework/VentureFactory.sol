// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @title SpaceDock - VentureFactory Contract
/// @author @okhaimie-dev
/// @notice This contract is used to create and manage ventures.
contract SpaceDock is AccessControl {
    using Counters for Counters.Counter;
    Counters.Counter private _ventureIdCounter;

    string private _ventureBaseURI;
    bytes32 public constant VENTURE_FOUNDER_ROLE = keccak256("VENTURE_FOUNDER_ROLE");

    /**
     * @dev Struct to store details about each venture.
     */

    struct Profiles {
        string website;
        string twitter;
        string github;
        string blog;
    }

    struct VentureData {
        string name;
        string thumbnailUrl;
        string about;
        Profiles profiles;
        address op_multisig;
    }

    struct Venture {
        VentureData data;
        address founder;
        uint256 createdAt;
    }

    /**
     * @dev Mapping to associate a venture ID with its Venture struct.
     */
    mapping(uint256 => Venture) public ventures;

    /**
     * @dev Event emitted when a new venture is created.
     * @param ventureId The ID of the venture.
     */
    event VentureCreated(uint256 indexed ventureId, VentureData data , address indexed founder, uint256 createdAt);

    /**
     * @dev Event emitted when the venture base URI is updated.
     * @param founder The address of the venture founder who updated the base URI.
     * @param ventureBaseURI The updated base URI for the ventures.
     */
    event VentureBaseURIUpdated(address indexed founder, string ventureBaseURI);

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @dev Set the base URI for retrieving venture metadata.
     * @param baseURI_ The new base URI to set.
     */
    function setBaseURI(string memory baseURI_) external {
        require(hasRole(VENTURE_FOUNDER_ROLE, msg.sender) || hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Unauthorized");
        _ventureBaseURI = baseURI_;
        emit VentureBaseURIUpdated(msg.sender, baseURI_);
    }

    /**
     * @dev Create a new venture.
     */
    function createVenture(VentureData memory data) public {
        _ventureIdCounter.increment();
        uint256 ventureId = _ventureIdCounter.current();

        // Save project details
        ventures[ventureId] = Venture({
            data: data,
            founder: msg.sender,
            createdAt: block.timestamp
        });

        emit VentureCreated(ventureId, data, msg.sender, block.timestamp);
    }

    /**
     * @dev Retrieve the Base URI for a specific venture.
     * @param ventureId The ID of the venture.
     * @return The Base URI for the venture's metadata.
     * @notice The venture base URI must be set before calling this function.
     */
    function ventureURI(uint256 ventureId) public view returns (string memory) {
        require(ventureId > 0 && ventureId <= _ventureIdCounter.current(), "Invalid venture ID");
        return string(abi.encodePacked(_ventureBaseURI, ventures[ventureId].data.thumbnailUrl));
    }

    /**
     * @dev Grant the VENTURE_FOUNDER_ROLE to an address.
     * @param account The address to grant the role to.
     * @notice Only the contract owner can call this function.
     */
    function grantVentureFounderRole(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(VENTURE_FOUNDER_ROLE, account);
    }

    /**
     * @dev Revoke the VENTURE_FOUNDER_ROLE from an address.
     * @param account The address to revoke the role from.
     * @notice Only the contract owner can call this function.
     */
    function revokeVentureFounderRole(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        revokeRole(VENTURE_FOUNDER_ROLE, account);
    }

    /**
     * @dev Check if an address has the VENTURE_FOUNDER_ROLE.
     * @param account The address to check.
     * @return A boolean indicating if the address has the role.
     */
    function hasVentureFounderRole(address account) public view returns (bool) {
        return hasRole(VENTURE_FOUNDER_ROLE, account);
    }

}
