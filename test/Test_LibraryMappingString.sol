// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.7;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

import { LibraryMappingString } from "../contracts/LibraryMappingString.sol";

///
contract Test_LibraryMappingString {
    using LibraryMappingString for mapping(string => string);
    mapping(string => string) public data;

    string _key = "key";
    string _value = "value";
    string _default_value = "default";

    ///
    function afterEach() public {
        if (data.has(_key)) {
            data.remove(_key);
        }
    }

    ///
    function test_get_error() public {
        try data.get(_key) returns (string memory _result) {
            Assert.equal(_result, _key, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                "LibraryMappingString.get: value not defined",
                "Caught unexpected error reason"
            );
        }
    }

    ///
    function test_getOrElse() public {
        string memory _got = data.getOrElse(_key, _default_value);
        Assert.equal(_got, _default_value, "Failed to get default value");
    }

    ///
    function test_getOrError() public {
        string memory _custom_reason = "test_getOrError: customized error";
        try data.getOrError(_key, _custom_reason) returns (
            string memory _result
        ) {
            Assert.equal(_result, _key, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                _custom_reason,
                "Caught unexpected error reason"
            );
        }
    }

    ///
    function test_has() public {
        Assert.isFalse(data.has(_key), "Somehow key/value was defined");
        data.set(_key, _value);
        Assert.isTrue(data.has(_key), "Failed to define key/value pair");
    }

    ///
    function test_overwrite() public {
        data.set(_key, _value);
        string memory _got = data.get(_key);
        Assert.equal(_got, _value, "Failed to get expected value");
        data.overwrite(_key, _default_value);
        string memory _new_got = data.get(_key);
        Assert.equal(_new_got, _default_value, "Failed to get expected value");
    }

    ///
    function test_overwrite_error() public {
        try data.overwrite(_key, "") {
            Assert.isTrue(false, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                'LibraryMappingString.overwrite: value cannot be ""',
                "Caught unexpected error reason"
            );
        }
    }

    ///
    function test_overwriteOrError() public {
        string
            memory _custom_reason = "test_overwriteOrError: customized error";
        try data.overwriteOrError(_key, "", _custom_reason) {
            Assert.isTrue(false, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                _custom_reason,
                "Caught unexpected error reason"
            );
        }
    }

    ///
    function test_remove_error() public {
        try data.remove(_key) returns (string memory _result) {
            Assert.equal(_result, _key, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                "LibraryMappingString.remove: value not defined",
                "Caught unexpected error reason"
            );
        }
    }

    ///
    function test_removeOrError() public {
        string memory _custom_reason = "test_removeOrError: customized error";
        try data.removeOrError(_key, _custom_reason) returns (
            string memory _result
        ) {
            Assert.equal(_result, _key, "Failed to catch error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                _custom_reason,
                "Caught unexpected error reason"
            );
        }
    }

    ///
    function test_set() public {
        data.set(_key, _value);
        string memory _got = data.get(_key);
        Assert.equal(_got, _value, "Failed to get expected value");
    }

    ///
    function test_set_error() public {
        data.set(_key, _value);
        try data.set(_key, _value) {
            Assert.isTrue(false, "Failed to catch expected error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                "LibraryMappingString.set: value already defined",
                "Caught unexpected error reason"
            );
        }
        data.remove(_key);
        Assert.isFalse(data.has(_key), "Failed to remove value by key");
    }

    ///
    function test_setOrError() public {
        string memory _custom_reason = "test_setOrError: customized error";
        data.set(_key, _value);
        try data.setOrError(_key, _value, _custom_reason) {
            Assert.isTrue(false, "Failed to catch expected error");
        } catch Error(string memory _reason) {
            Assert.equal(
                _reason,
                _custom_reason,
                "Caught unexpected error reason"
            );
        }
        data.remove(_key);
        Assert.isFalse(data.has(_key), "Failed to remove value by key");
    }
}
