# Library Mapping String
[heading__top]:
  #library-mapping-string
  "&#x2B06; Solidity library for mapping of string key/value pairs"


Solidity library for mapping of string key/value pairs


## [![Byte size of Library Mapping String][badge__main__library_mapping_string__source_code]][library_mapping_string__main__source_code] [![Open Issues][badge__issues__library_mapping_string]][issues__library_mapping_string] [![Open Pull Requests][badge__pull_requests__library_mapping_string]][pull_requests__library_mapping_string] [![Latest commits][badge__commits__library_mapping_string__main]][commits__library_mapping_string__main] [![Build Status][badge__github_actions]][activity_log__github_actions]


---


- [:arrow_up: Top of Document][heading__top]

- [:building_construction: Requirements][heading__requirements]

- [:zap: Quick Start][heading__quick_start]

- [&#x1F9F0; Usage][heading__usage]

- [&#x1F523; API][heading__api]
  - [Library `LibraryMappingString`][heading__library_librarymappingstring]
    - [Method `get`][heading__method_get]
    - [Method `getOrElse`][heading__method_getorelse]
    - [Method `getOrError`][heading__method_getorerror]
    - [Method `has`][heading__method_has]
    - [Method `overwrite`][heading__method_overwrite]
    - [Method `overwriteOrError`][heading__method_overwriteorerror]
    - [Method `remove`][heading__method_remove]
    - [Method `removeOrError`][heading__method_removeorerror]
    - [Method `set`][heading__method_set]
    - [Method `setOrError`][heading__method_setorerror]

- [&#x1F5D2; Notes][heading__notes]

- [:chart_with_upwards_trend: Contributing][heading__contributing]
  - [:trident: Forking][heading__forking]
  - [:currency_exchange: Sponsor][heading__sponsor]

- [:card_index: Attribution][heading__attribution]

- [:balance_scale: Licensing][heading__license]


---



## Requirements
[heading__requirements]:
  #requirements
  "&#x1F3D7; Prerequisites and/or dependencies that this project needs to function properly"


> Prerequisites and/or dependencies that this project needs to function properly


This project utilizes Truffle for organization of source code and tests, thus
it is recommended to install Truffle _globally_ to your current user account


```Bash
npm install -g truffle
```


______


## Quick Start
[heading__quick_start]:
  #quick-start
  "&#9889; Perhaps as easy as one, 2.0,..."


> Perhaps as easy as one, 2.0,...


NPM and Truffle are recommended for importing and managing project dependencies


```Bash
cd your_project

npm install @solidity-utilities/library-mapping-string
```


> Note, source code for this library will be located within the
> `node_modules/@solidity-utilities/library-mapping-string` directory of
> _`your_project`_ root


Solidity contracts may then import code via similar syntax as shown


```Solidity
import {
    LibraryMappingString
} from "@solidity-utilities/library-mapping-string/contracts/LibraryMappingString.sol";
```


> Note, above path is **not** relative (ie. there's no `./` preceding the file
> path) which causes Truffle to search the `node_modules` sub-directories


Review the
[Truffle -- Package Management via NPM][truffle__package_management_via_npm]
documentation for more installation details.


---


> In the future, after beta testers have reported bugs and feature requests, it
> should be possible to link the deployed `LibraryMappingString` via Truffle
> migration similar to the following.
>
>
> **`migrations/2_your_contract.js`**
>
>
>     const LibraryMappingString = artifacts.require("LibraryMappingString");
>     const YourContract = artifacts.require("YourContract");
>
>     module.exports = (deployer, _network, _accounts) {
>       LibraryMappingString.address = "...";
>       deployer.deploy(LibraryMappingString, { overwrite: false });
>       deployer.link(LibraryMappingString, YourContract);
>       deployer.deploy(YourContract);
>     };


______


## Usage
[heading__usage]:
  #usage
  "&#x1F9F0; How to utilize this repository"


> How to utilize this repository


Write contract(s) that make use of, and extend, `LibraryMappingString` features.


```Solidity
// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.7;

import {
    LibraryMappingString
} from "@solidity-utilities/mapped-addresses/contracts/LibraryMappingString.sol";

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
```


Above the `StringStorage` contract;


- maintains a list of keys

- restricts mutation to owner only


There is likely much that can be accomplished by leveraging these abstractions,
check the [API][heading__api] section for full set of features available.  And
review the
[`test/test__examples__StringStorage.js`][source__test__test__examples__stringstorage_js]
file for inspiration on how to use this library within projects.


______


## API
[heading__api]:
  #api
  "Application Programming Interfaces for Solidity smart contracts"


> Application Programming Interfaces for Solidity smart contracts


**Developer note** -> Check the [`test/`][source__test] directory for
JavaScript and Solidity usage examples


---


### Library `LibraryMappingString`
[heading__library_librarymappingstring]:
  #library-librarymappingstring
  "Organizes methods that may be attached to `mapping(string => string)` type"


> Organizes methods that may be attached to `mapping(string => string)` type


**Warning** any value of `""` is treated as _null_ or _undefined_


**Source** [`contracts/LibraryMappingString.sol`][source__contracts__librarymappingstring_sol]


---


#### Method `get`
[heading__method_get]:
  #method-get
  "Retrieves stored value `string` or throws an error if _undefined_"


> Retrieves stored value `string` or throws an error if _undefined_


[**Source**][source__contracts__librarymappingstring_sol__get] `get(mapping(string => string) _self, string _key)`


**Parameters**


- `_self` **{mapping(string => string)}** Mapping of key/value `string` pairs

- `_key` **{string}** Mapping key `string` to lookup corresponding value `string` for


**Returns** -> **{string}** Value for given key `string`


**Throws** -> **{Error}** `"LibraryMappingString.get: value not defined"`


**Developer note** -> Passes parameters to `getOrError` with default Error
`_reason` to throw


---


#### Method `getOrElse`
[heading__method_getorelse]:
  #method-getorelse
  "Retrieves stored value `string` or provided default `string` if _undefined_"


> Retrieves stored value `string` or provided default `string` if _undefined_


[**Source**][source__contracts__librarymappingstring_sol__getorelse] `getOrElse(mapping(string => string) _self, string _key, string _default)`


**Parameters**


- `_self` **{mapping(string => string)}** Mapping of key/value `string` pairs

- `_key` **{string}** Mapping key `string` to lookup corresponding value `string` for

- `_default` **{string}** Value to return if key `string` lookup is _undefined_


**Returns** -> **{string}** Value `string` for given key `string` or `_default` if _undefined_


---


#### Method `getOrError`
[heading__method_getorerror]:
  #method-getorerror
  "Allows for defining custom error reason if value `string` is _undefined_"


> Allows for defining custom error reason if value `string` is _undefined_


[**Source**][source__contracts__librarymappingstring_sol__getorerror] `getOrError(mapping(string => string) _self, string _key, string _reason)`


**Parameters**


- `_self` **{mapping(string => string)}** Mapping of key/value `string` pairs

- `_key` **{string}** Mapping key `string` to lookup corresponding value `string` for

- `_reason` **{string}** Custom error message to throw if value `string` is _undefined_


**Returns** -> **{string}** Value for given key `string`


**Throws** -> **{Error}** `_reason` if value is _undefined_


---


#### Method `has`
[heading__method_has]:
  #method-has
  "Check if `string` key has a corresponding value `string` defined"


> Check if `string` key has a corresponding value `string` defined


[**Source**][source__contracts__librarymappingstring_sol__has] `has(mapping(string => string) _self, string _key)`


**Parameters**


- `_self` **{mapping(string => string)}** Mapping of key/value `string` pairs

- `_key` **{string}** Mapping key to check if value `string` is defined


**Returns** -> **{bool}** `true` if value `string` is defined, or `false` if _undefined_


---


#### Method `overwrite`
[heading__method_overwrite]:
  #method-overwrite
  "Store `_value` under given `_key` **without** preventing unintentional overwrites"


> Store `_value` under given `_key` **without** preventing unintentional overwrites


[**Source**][source__contracts__librarymappingstring_sol__overwrite] `overwrite(mapping(string => string) _self, string _key, string _value)`


**Parameters**


- `_self` **{mapping(string => string)}** Mapping of key/value `string` pairs

- `_key` **{string}** Mapping key to set corresponding value `string` for

- `_value` **{string}** Mapping value to set


**Throws** ->  **{Error}** `"LibraryMappingString.overwrite: value cannot be """`


**Developer note** -> Passes parameters to `overwriteOrError` with default
Error `_reason` to throw


---


#### Method `overwriteOrError`
[heading__method_overwriteorerror]:
  #method-overwriteorerror
  "Store `_value` under given `_key` **without** preventing unintentional overwrites"


> Store `_value` under given `_key` **without** preventing unintentional overwrites


[**Source**][source__contracts__librarymappingstring_sol__overwriteorerror] `overwriteOrError(mapping(string => string) _self, string _key, string _value, string _reason)`


**Parameters**


- `_self` **{mapping(string => string)}** Mapping of key/value `string` pairs

- `_key` **{string}** Mapping key to set corresponding value `string` for

- `_value` **{string}** Mapping value to set

- `_reason` **{string}** Custom error message to present if value `string` is `""`


**Throws** -> **{Error}** `_reason` if value is `""`


---


#### Method `remove`
[heading__method_remove]:
  #method-remove
  "Delete value `string` for given `_key`"


> Delete value `string` for given `_key`


[**Source**][source__contracts__librarymappingstring_sol__remove] `remove(mapping(string => string) _self, string _key)`


**Parameters**


- `_self` **{mapping(string => string)}** Mapping of key/value `string` pairs

- `_key` **{string}** Mapping key to delete corresponding value `string` for


**Returns** -> **{string}** Value for given key `string`


**Throws** -> **{Error}** `"LibraryMappingString.remove: value not defined"`


**Developer note** -> Passes parameters to `removeOrError` with default Error
`_reason` to throw


---


#### Method `removeOrError`
[heading__method_removeorerror]:
  #method-removeorerror
  "Delete value `string` for given `_key`"


> Delete value `string` for given `_key`


[**Source**][source__contracts__librarymappingstring_sol__removeorerror] `removeOrError(mapping(string => string) _self, string _key, string _reason)`


**Parameters**


- `_self` **{mapping(string => string)}** Mapping of key/value `string` pairs

- `_key` **{string}** Mapping key to delete corresponding value `string` for

- `_reason` **{string}** Custom error message to throw if value `string` is _undefined_


**Returns** -> {string} Stored value `string` for given key `string`


**Throws** -> **{Error}** `_reason` if value is _undefined_


---


#### Method `set`
[heading__method_set]:
  #method-set
  "Store `_value` under given `_key` while preventing unintentional overwrites"


> Store `_value` under given `_key` while preventing unintentional overwrites


[**Source**][source__contracts__librarymappingstring_sol__set] `set(mapping(string => string) _self, string _key, string _value)`


**Parameters**


- `_self` **{mapping(string => string)}** Mapping of key/value `string` pairs

- `_key` **{string}** Mapping key to set corresponding value `string` for

- `_value` **{string}** Mapping value to set


**Throws**


- **{Error}** `"LibraryMappingString.set: value already defined"`

- **{Error}** `"LibraryMappingString.setOrError: value cannot be """`


**Developer note** -> Passes parameters to `setOrError` with default Error
`_reason` to throw


---


#### Method `setOrError`
[heading__method_setorerror]:
  #method-setorerror
  "Store `_value` under given `_key` while preventing unintentional overwrites"


> Stores `_value` under given `_key` while preventing unintentional overwrites


[**Source**][source__contracts__librarymappingstring_sol__setorerror] `setOrError(mapping(string => string) _self, string _key, string _value, string _reason)`


**Parameters**


- `_self` **{mapping(string => string)}** Mapping of key/value `string` pairs

- `_key` **{string}** Mapping key to set corresponding value `string` for

- `_value` **{string}** Mapping value to set

- `_reason` **{string}** Custom error message to present if value `string` is defined


**Throws**


- **{Error}**  `_reason` if value is defined

- **{Error}** `"LibraryMappingString.setOrError: value cannot be """`


______


## Notes
[heading__notes]:
  #notes
  "&#x1F5D2; Additional things to keep in mind when developing"


> Additional things to keep in mind when developing


Implementing
[`selfdestruct`](https://docs.soliditylang.org/en/v0.4.21/units-and-global-variables.html?highlight=selfdestruct#contract-related)
on contracts that utilize this library is recommended. Because as explained by
[Ethereum Storage](https://ethereum.org/en/developers/docs/storage/),
it is **not** a good idea to store much data, especially dynamically sized
types such as strings, on the Ethereum blockchain.


Instead it be better to store large amounts of data, such as files, via
services such as;


- [0 Chain][0_chain]

- [Arweave][arweave]

- [Swarm][swarm]

- [File Coin][file_coin]

- [STORJ][storj]

- [Safe Network][safe_network]

- [SkyNet][skynet]


... and then use this library for tracking references to such assets.


Additionally it is a **very bad idea** to store any data that may be considered
private, even if encrypted, within contracts.


---


This repository may not be feature complete and/or fully functional, Pull Requests that add features or fix bugs are certainly welcomed.


______


## Contributing
[heading__contributing]:
  #contributing
  "&#x1F4C8; Options for contributing to library-mapping-string and solidity-utilities"


> Options for contributing to library-mapping-string and solidity-utilities


---


### Forking
[heading__forking]:
  #forking
  "&#x1F531; Tips for forking library-mapping-string"


Start making a [Fork][library_mapping_string__fork_it] of this repository to an account that you have write permissions for.


- Add remote for fork URL. The URL syntax is _`git@github.com:<NAME>/<REPO>.git`_...


```Bash
cd ~/git/hub/solidity-utilities/library-mapping-string

git remote add fork git@github.com:<NAME>/library-mapping-string.git
```


- Commit your changes and push to your fork, eg. to fix an issue...


```Bash
cd ~/git/hub/solidity-utilities/library-mapping-string


git commit -F- <<'EOF'
:bug: Fixes #42 Issue


**Edits**


- `<SCRIPT-NAME>` script, fixes some bug reported in issue
EOF


git push fork main
```


> Note, the `-u` option may be used to set `fork` as the default remote, eg. _`git push -u fork main`_ however, this will also default the `fork` remote for pulling from too! Meaning that pulling updates from `origin` must be done explicitly, eg. _`git pull origin main`_


- Then on GitHub submit a Pull Request through the Web-UI, the URL syntax is _`https://github.com/<NAME>/<REPO>/pull/new/<BRANCH>`_


> Note; to decrease the chances of your Pull Request needing modifications before being accepted, please check the [dot-github](https://github.com/solidity-utilities/.github) repository for detailed contributing guidelines.


---


### Sponsor
  [heading__sponsor]:
  #sponsor
  "&#x1F4B1; Methods for financially supporting solidity-utilities that maintains library-mapping-string"


Thanks for even considering it!


Via Liberapay you may <sub>[![sponsor__shields_io__liberapay]][sponsor__link__liberapay]</sub> on a repeating basis.


Regardless of if you're able to financially support projects such as library-mapping-string that solidity-utilities maintains, please consider sharing projects that are useful with others, because one of the goals of maintaining Open Source repositories is to provide value to the community.


______


## Attribution
[heading__attribution]:
  #attribution
  "&#x1F4C7; Resources that where helpful in building this project so far."


- [GitHub -- `github-utilities/make-readme`](https://github.com/github-utilities/make-readme)


______


## License
[heading__license]:
  #license
  "&#x2696; Legal side of Open Source"


```
Solidity library for mapping of string key/value pairs
Copyright (C) 2021 S0AndS0

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```


For further details review full length version of [AGPL-3.0][branch__current__license] License.



[branch__current__license]:
  /LICENSE
  "&#x2696; Full length version of AGPL-3.0 License"


[badge__commits__library_mapping_string__main]:
  https://img.shields.io/github/last-commit/solidity-utilities/library-mapping-string/main.svg

[commits__library_mapping_string__main]:
  https://github.com/solidity-utilities/library-mapping-string/commits/main
  "&#x1F4DD; History of changes on this branch"


[library_mapping_string__community]:
  https://github.com/solidity-utilities/library-mapping-string/community
  "&#x1F331; Dedicated to functioning code"


[issues__library_mapping_string]:
  https://github.com/solidity-utilities/library-mapping-string/issues
  "&#x2622; Search for and _bump_ existing issues or open new issues for project maintainer to address."

[library_mapping_string__fork_it]:
  https://github.com/solidity-utilities/library-mapping-string/fork
  "&#x1F531; Fork it!"

[pull_requests__library_mapping_string]:
  https://github.com/solidity-utilities/library-mapping-string/pulls
  "&#x1F3D7; Pull Request friendly, though please check the Community guidelines"

[library_mapping_string__main__source_code]:
  https://github.com/solidity-utilities/library-mapping-string/
  "&#x2328; Project source!"

[badge__issues__library_mapping_string]:
  https://img.shields.io/github/issues/solidity-utilities/library-mapping-string.svg

[badge__pull_requests__library_mapping_string]:
  https://img.shields.io/github/issues-pr/solidity-utilities/library-mapping-string.svg

[badge__main__library_mapping_string__source_code]:
  https://img.shields.io/github/repo-size/solidity-utilities/library-mapping-string


[0_chain]: https://0chain.net/

[arweave]: https://www.arweave.org/

[file_coin]: https://filecoin.io/

[safe_network]: https://safenetwork.tech/

[storj]: https://storj.io/

[swarm]: https://ethersphere.github.io/swarm-home/

[skynet]: https://siasky.net/


[sponsor__shields_io__liberapay]:
  https://img.shields.io/static/v1?logo=liberapay&label=Sponsor&message=solidity-utilities

[sponsor__link__liberapay]:
  https://liberapay.com/solidity-utilities
  "&#x1F4B1; Sponsor developments and projects that solidity-utilities maintains via Liberapay"


[badge__github_actions]:
  https://img.shields.io/github/workflow/status/solidity-utilities/library-mapping-string/test?event=push

[activity_log__github_actions]:
  https://github.com/solidity-utilities/library-mapping-string/deployments/activity_log


[truffle__package_management_via_npm]:
  https://www.trufflesuite.com/docs/truffle/getting-started/package-management-via-npm
  "Documentation on how to install, import, and interact with Solidity packages"


[source__test]:
  test
  "CI/CD (Continuous Integration/Deployment) tests and examples"

[source__test__test__examples__stringstorage_js]:
  test/test__examples__StringStorage.js
  "JavaScript code for testing test/examples/StringStorage.sol"

[source__contracts__librarymappingstring_sol]:
  contracts/LibraryMappingString.sol
  "Solidity code for LibraryMappingString"

[source__contracts__librarymappingstring_sol__get]:
  contracts/LibraryMappingString.sol#L8
  "Solidity code for LibraryMappingString.get function"

[source__contracts__librarymappingstring_sol__getorelse]:
  contracts/LibraryMappingString.sol#L27
  "Solidity code for LibraryMappingString.getOrElse function"

[source__contracts__librarymappingstring_sol__getorerror]:
  contracts/LibraryMappingString.sol#L44
  "Solidity code for LibraryMappingString.getOrError function"

[source__contracts__librarymappingstring_sol__has]:
  contracts/LibraryMappingString.sol#L60
  "Solidity code for LibraryMappingString.has function"

[source__contracts__librarymappingstring_sol__overwrite]:
  contracts/LibraryMappingString.sol#L72
  "Solidity code for LibraryMappingString.overwrite function"

[source__contracts__librarymappingstring_sol__overwriteorerror]:
  contracts/LibraryMappingString.sol#L91
  "Solidity code for LibraryMappingString.overwriteOrError function"

[source__contracts__librarymappingstring_sol__remove]:
  contracts/LibraryMappingString.sol#L107
  "Solidity code for LibraryMappingString.remove function"

[source__contracts__librarymappingstring_sol__removeorerror]:
  contracts/LibraryMappingString.sol#L125
  "Solidity code for LibraryMappingString.removeOrError function"

[source__contracts__librarymappingstring_sol__set]:
  contracts/LibraryMappingString.sol#L142
  "Solidity code for LibraryMappingString.set function"

[source__contracts__librarymappingstring_sol__setorerror]:
  contracts/LibraryMappingString.sol#L162
  "Solidity code for LibraryMappingString.setOrError function"

