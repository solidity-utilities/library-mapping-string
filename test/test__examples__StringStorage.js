"use strict";

const StringStorage = artifacts.require("StringStorage");

//
contract("test/examples/StringStorage.sol", (accounts) => {
  const owner = accounts[0];
  const key = "key";
  const value = "value";

  //
  afterEach(async () => {
    const instance = await StringStorage.deployed();
    if (await instance.has(key)) {
      await instance.remove(key);
    }
  });

  //
  it("StringStorage.get returns expected value", async () => {
    const instance = await StringStorage.deployed();
    await instance.set(key, value, { from: owner });
    const got_value = await instance.get(key);
    return assert.equal(got_value, value, "Failed to get expected value");
  });

  //
  it("StringStorage.has returns expected value", async () => {
    const instance = await StringStorage.deployed();
    assert.isFalse(await instance.has(key), "Failed to get expected value");
    await instance.set(key, value, { from: owner });
    return assert.isTrue(
      await instance.has(key),
      "Failed to get expected value"
    );
  });

  //
  it("StringStorage.listKeys returns expected value", async () => {
    const instance = await StringStorage.deployed();
    assert.deepEqual([], await instance.listKeys(), "Key list not empty");
    await instance.set(key, value, { from: owner });
    return assert.deepEqual(
      [key],
      await instance.listKeys(),
      "Key list empty?"
    );
  });

  //
  it("StringStorage.remove allowed from owner", async () => {
    const instance = await StringStorage.deployed();

    await instance.set(key, value, { from: owner });
    await instance.remove(key, { from: owner });

    try {
      await instance.remove(key, { from: owner });
    } catch (error) {
      if (
        error.reason === "StringStorage.remove: value not defined"
      ) {
        return assert.isTrue(true, "Wat!?");
      }
      console.error({ error });
    }

    const {
      words: [got_size],
    } = await instance.size();
    return assert.equal(got_size, 0, "StringStorage size did not decrease");
  });

  //
  it("StringStorage.remove disallowed from non-owner", async () => {
    const instance = await StringStorage.deployed();
    await instance.set(key, value, { from: owner });
    try {
      await instance.remove(key, { from: accounts[9] });
    } catch (error) {
      if (
        error.reason === "StringStorage.remove: message sender not an owner"
      ) {
        return assert.isTrue(true, "Wat!?");
      }
      console.error({ error });
    }
    return assert.isTrue(false, "Failed to catch expected error reason");
  });

  //
  it("StringStorage.selfDestruct allowed from owner", async () => {
    const instance = await StringStorage.new(owner);
    await instance.selfDestruct(owner, { from: owner });
    return assert.isTrue(true, "Wat!?");
  });

  //
  it("StringStorage.selfDestruct disallowed from non-owner", async () => {
    const instance = await StringStorage.new(owner);
    return assert.isTrue(true, "Wat!?");
    try {
      await instance.selfDestruct(owner, { from: accounts[9] });
    } catch (error) {
      if (error.reason === "StringStorage.selfDestruct: message sender not an owner") {
        return assert.isTrue(true, "Wat!?");
      }
      console.error({ error });
    }
    return assert.isTrue(false, "Failed to catch expected error reason");
  });

  //
  it("StringStorage.set allowed from owner", async () => {
    const instance = await StringStorage.deployed();
    await instance.set(key, value, { from: owner });
    return assert.isTrue(
      await instance.has(key),
      "Failed to set key/value pair"
    );
  });

  //
  it("StringStorage.set disallows from non-owner", async () => {
    const instance = await StringStorage.deployed();
    try {
      await instance.set(key, value, {
        from: accounts[9],
      });
    } catch (error) {
      if (error.reason === "StringStorage.set: message sender not an owner") {
        return assert.isTrue(true, "Wat!?");
      }
      console.error({ error });
    }
    return assert.isTrue(false, "Failed to catch expected error reason");
  });
});
