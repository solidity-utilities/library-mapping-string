"use strict";

const LibraryMappingString = artifacts.require("LibraryMappingString");

module.exports = (deployer, _network, _accounts) => {
  deployer.deploy(LibraryMappingString);
};
