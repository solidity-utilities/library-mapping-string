// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.7;

// import {
//     LibraryMappingString
// } from "@solidity-utilities/mapped-addresses/contracts/LibraryMappingString.sol";
import { LibraryMappingString } from "../../contracts/LibraryMappingString.sol";

/// @title Programming interface for storing string mapping data
/// @author S0AndS0
contract StringStorage {
    using LibraryMappingString for mapping(string => string);
    mapping(string => string) data;
    mapping(string => uint256) indexes;
    string[] public keys;
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    /// @notice Requires message sender to be an instance owner
    /// @param _caller {string} Function name that implements this modifier
    modifier onlyOwner(string memory _caller) {
        string memory _message = string(
            abi.encodePacked(
                "StringStorage.",
                _caller,
                ": message sender not an owner"
            )
        );
        require(msg.sender == owner, _message);
        _;
    }

    /// @notice Retrieves stored value `string` or throws an error if _undefined_
    /// @dev Passes `_key` to `data.getOrError` with default Error `_reason` to throw
    /// @param _key **{string}** Key mapped to value
    /// @return **{string}** Value for corresponding `_key`
    /// @custom:throws **{Error}** `"StringStorage.get: value not defined"`
    function get(string calldata _key) external view returns (string memory) {
        return data.getOrError(_key, "StringStorage.get: value not defined");
    }

    /// @notice Check if `string` key has a corresponding value `string` defined
    /// @dev Forwards parameter to `data.has`
    /// @return **{bool}**
    function has(string calldata _key) external view returns (bool) {
        return data.has(_key);
    }

    /// @notice Allow full read access to all `keys` stored within `data`
    /// @dev **Warning** Key order is not guarantied
    /// @return **{string[]}**
    function listKeys() external view returns (string[] memory) {
        return keys;
    }

    /// @notice Delete value `string` for given `_key`
    /// @dev **Warning** Overwrites current key with last key
    /// @dev Passes parameters to `data.removeOrError` with default Error `_reason` to throw
    /// @return **{string}**
    /// @custom:javascript Returns transaction object
    /// @custom:throws **{Error}** `"StringStorage.remove: message sender not an owner"`
    /// @custom:throws **{Error}** `"StringStorage.remove: value not defined"`
    /// :bookmark: Track test fixes and dependency upgrades
    function remove(string calldata _key)
        external
        onlyOwner("remove")
        returns (string memory)
    {
        string memory _value = data.removeOrError(
            _key,
            "StringStorage.remove: value not defined"
        );
        uint256 _last_index = keys.length - 1;
        string memory _last_key = keys[_last_index];
        if (keys.length > 1) {
            uint256 _target_index = indexes[_key];
            keys[_target_index] = keys[_last_index];
            indexes[_last_key] = _target_index;
        }
        delete indexes[_last_key];
        keys.pop();
        return _value;
    }

    /// @notice Call `selfdestruct` with provided address
    /// @param _to **{address}** Where to transfer any funds this contract has
    /// @custom:throws **{Error}** `"StringStorage.selfDestruct: message sender not an owner"`
    function selfDestruct(address payable _to)
        external
        onlyOwner("selfDestruct")
    {
        selfdestruct(_to);
    }

    /// @notice Store `_value` under given `_key` while preventing unintentional overwrites
    /// @param _key **{string}** Mapping key to set corresponding value `string` for
    /// @param _value **{string}** Mapping value to set
    /// @custom:throws **{Error}** `"StringStorage.set: message sender not an owner"`
    /// @custom:throws **{Error}** `"StringStorage.set: value already defined"`
    function set(string calldata _key, string calldata _value)
        external
        onlyOwner("set")
    {
        data.setOrError(
            _key,
            _value,
            "StringStorage.set: value already defined"
        );
        keys.push(_key);
    }

    /// @notice Number of key/value `address` pairs stored
    /// @dev Cannot depend on results being valid if mutation is allowed between calls
    /// @return **{uint256}** Length of `keys` array
    /// @custom:javascript Returns `BN` data object
    function size() external view returns (uint256) {
        return keys.length;
    }
}
