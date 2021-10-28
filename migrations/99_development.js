"use strict";

module.exports = (deployer, network, accounts) => {
  if (network !== "development") {
    return;
  }

  console.log("Notice: detected network of development kind ->", { network });

  const LibraryMappingString = artifacts.require("LibraryMappingString");
  const StringStorage = artifacts.require("StringStorage");

  const owner_StringStorage = accounts[0];

  deployer.deploy(LibraryMappingString);
  deployer.link(LibraryMappingString, StringStorage);
  deployer.deploy(StringStorage, owner_StringStorage);
};
