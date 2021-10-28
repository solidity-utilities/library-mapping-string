// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.7;

/// @title Organizes methods that may be attached to `mapping(string => string)` type
/// @notice **Warning** any value of `""` is treated as _null_ or _undefined_
/// @author S0AndS0
library LibraryMappingString {
    /// @notice Retrieves stored value `string` or throws an error if _undefined_
    /// @dev Passes parameters to `getOrError` with default Error `_reason` to throw
    /// @param _self **{mapping(string => string)}** Mapping of key/value `string` pairs
    /// @param _key **{string}** Mapping key `string` to lookup corresponding value `string` for
    /// @return **{string}** Value for given key `string`
    /// @custom:throws **{Error}** `"LibraryMappingString.get: value not defined"`
    function get(mapping(string => string) storage _self, string calldata _key)
        external
        view
        returns (string memory)
    {
        return
            getOrError(
                _self,
                _key,
                "LibraryMappingString.get: value not defined"
            );
    }

    /// @notice Retrieves stored value `string` or provided default `string` if _undefined_
    /// @param _self **{mapping(string => string)}** Mapping of key/value `string` pairs
    /// @param _key **{string}** Mapping key `string` to lookup corresponding value `string` for
    /// @param _default **{string}** Value to return if key `string` lookup is _undefined_
    /// @return **{string}** Value `string` for given key `string` or `_default` if _undefined_
    function getOrElse(
        mapping(string => string) storage _self,
        string calldata _key,
        string memory _default
    ) external view returns (string memory) {
        string memory _value = _self[_key];
        return
            keccak256(bytes(_value)) != keccak256(bytes(""))
                ? _value
                : _default;
    }

    /// @notice Allows for defining custom error reason if value `string` is _undefined_
    /// @param _self **{mapping(string => string)}** Mapping of key/value `string` pairs
    /// @param _key **{string}** Mapping key `string` to lookup corresponding value `string` for
    /// @param _reason **{string}** Custom error message to throw if value `string` is _undefined_
    /// @return **{string}** Value for given key `string`
    /// @custom:throws **{Error}** _reason if value is _undefined_
    function getOrError(
        mapping(string => string) storage _self,
        string calldata _key,
        string memory _reason
    ) public view returns (string memory) {
        string memory _value = _self[_key];
        require(keccak256(bytes(_value)) != keccak256(bytes("")), _reason);
        return _value;
    }

    /// @notice Check if `string` key has a corresponding value `string` defined
    /// @param _self **{mapping(string => string)}** Mapping of key/value `string` pairs
    /// @param _key **{string}** Mapping key to check if value `string` is defined
    /// @return **{bool}** true if value `string` is defined, or `false` if _undefined_
    function has(mapping(string => string) storage _self, string calldata _key)
        external
        view
        returns (bool)
    {
        return keccak256(bytes(_self[_key])) != keccak256(bytes(""));
    }

    /// @notice Store `_value` under given `_key` **without** preventing unintentional overwrites
    /// @dev Passes parameters to `overwriteOrError` with default Error `_reason` to throw
    /// @param _self **{mapping(string => string)}** Mapping of key/value `string` pairs
    /// @param _key **{string}** Mapping key to set corresponding value `string` for
    /// @param _value **{string}** Mapping value to set
    /// @custom:throws **{Error}** `"LibraryMappingString.overwrite: value cannot be """`
    function overwrite(
        mapping(string => string) storage _self,
        string calldata _key,
        string calldata _value
    ) external {
        overwriteOrError(
            _self,
            _key,
            _value,
            'LibraryMappingString.overwrite: value cannot be ""'
        );
    }

    /// @notice Store `_value` under given `_key` **without** preventing unintentional overwrites
    /// @param _self **{mapping(string => string)}** Mapping of key/value `string` pairs
    /// @param _key **{string}** Mapping key to set corresponding value `string` for
    /// @param _value **{string}** Mapping value to set
    /// @param _reason **{string}** Custom error message to present if value `string` is `""`
    /// @custom:throws **{Error}** `_reason` if value is `""`
    function overwriteOrError(
        mapping(string => string) storage _self,
        string calldata _key,
        string calldata _value,
        string memory _reason
    ) public {
        require(keccak256(bytes(_value)) != keccak256(bytes("")), _reason);
        _self[_key] = _value;
    }

    /// @notice Delete value `string` for given `_key`
    /// @dev Passes parameters to `removeOrError` with default Error `_reason` to throw
    /// @param _self **{mapping(string => string)}** Mapping of key/value `string` pairs
    /// @param _key **{string}** Mapping key to delete corresponding value `string` for
    /// @return **{string}** Stored value `string` for given key `string`
    /// @custom:throws **{Error}** `"LibraryMappingString.remove: value not defined"`
    function remove(
        mapping(string => string) storage _self,
        string calldata _key
    ) external returns (string memory) {
        return
            removeOrError(
                _self,
                _key,
                "LibraryMappingString.remove: value not defined"
            );
    }

    /// @notice Delete value `string` for given `_key`
    /// @param _self **{mapping(string => string)}** Mapping of key/value `string` pairs
    /// @param _key **{string}** Mapping key to delete corresponding value `string` for
    /// @param _reason **{string}** Custom error message to throw if value `string` is _undefined_
    /// @return **{string}** Stored value `string` for given key `string`
    /// @custom:throws **{Error}** _reason if value is _undefined_
    function removeOrError(
        mapping(string => string) storage _self,
        string calldata _key,
        string memory _reason
    ) public returns (string memory) {
        string memory _value = _self[_key];
        require(keccak256(bytes(_value)) != keccak256(bytes("")), _reason);
        delete _self[_key];
        return _value;
    }

    /// @notice Store `_value` under given `_key` while preventing unintentional overwrites
    /// @dev Passes parameters to `setOrError` with default Error `_reason` to throw
    /// @param _self **{mapping(string => string)}** Mapping of key/value `string` pairs
    /// @param _key **{string}** Mapping key to set corresponding value `string` for
    /// @param _value **{string}** Mapping value to set
    /// @custom:throws **{Error}** `"LibraryMappingString.set: value already defined"`
    /// @custom:throws **{Error}** `"LibraryMappingString.setOrError: value cannot be """`
    function set(
        mapping(string => string) storage _self,
        string calldata _key,
        string calldata _value
    ) external {
        setOrError(
            _self,
            _key,
            _value,
            "LibraryMappingString.set: value already defined"
        );
    }

    /// @notice Store `_value` under given `_key` while preventing unintentional overwrites
    /// @param _self **{mapping(string => string)}** Mapping of key/value `string` pairs
    /// @param _key **{string}** Mapping key to set corresponding value `string` for
    /// @param _value **{string}** Mapping value to set
    /// @param _reason **{string}** Custom error message to present if value `string` is defined
    /// @custom:throws **{Error}** _reason if value is defined
    /// @custom:throws **{Error}** `"LibraryMappingString.setOrError: value cannot be """`
    function setOrError(
        mapping(string => string) storage _self,
        string calldata _key,
        string calldata _value,
        string memory _reason
    ) public {
        require(keccak256(bytes(_self[_key])) == keccak256(bytes("")), _reason);
        require(
            keccak256(bytes(_value)) != keccak256(bytes("")),
            'LibraryMappingString.setOrError: value cannot be ""'
        );
        _self[_key] = _value;
    }
}
