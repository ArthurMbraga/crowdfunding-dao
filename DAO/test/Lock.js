const {
  time,
  loadFixture,
***REMOVED*** = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue ***REMOVED*** = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect ***REMOVED*** = require("chai");

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployOneYearLockFixture() {
    const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
    const ONE_GWEI = 1_000_000_000;

    const lockedAmount = ONE_GWEI;
    const unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;

    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Lock = await ethers.getContractFactory("Lock");
    const lock = await Lock.deploy(unlockTime, { value: lockedAmount ***REMOVED***);

    return { lock, unlockTime, lockedAmount, owner, otherAccount ***REMOVED***;
  ***REMOVED***

  describe("Deployment", function () {
    it("Should set the right unlockTime", async function () {
      const { lock, unlockTime ***REMOVED*** = await loadFixture(deployOneYearLockFixture);

      expect(await lock.unlockTime()).to.equal(unlockTime);
    ***REMOVED***);

    it("Should set the right owner", async function () {
      const { lock, owner ***REMOVED*** = await loadFixture(deployOneYearLockFixture);

      expect(await lock.owner()).to.equal(owner.address);
    ***REMOVED***);

    it("Should receive and store the funds to lock", async function () {
      const { lock, lockedAmount ***REMOVED*** = await loadFixture(
        deployOneYearLockFixture
      );

      expect(await ethers.provider.getBalance(lock.target)).to.equal(
        lockedAmount
      );
    ***REMOVED***);

    it("Should fail if the unlockTime is not in the future", async function () {
      // We don't use the fixture here because we want a different deployment
      const latestTime = await time.latest();
      const Lock = await ethers.getContractFactory("Lock");
      await expect(Lock.deploy(latestTime, { value: 1 ***REMOVED***)).to.be.revertedWith(
        "Unlock time should be in the future"
      );
    ***REMOVED***);
  ***REMOVED***);

  describe("Withdrawals", function () {
    describe("Validations", function () {
      it("Should revert with the right error if called too soon", async function () {
        const { lock ***REMOVED*** = await loadFixture(deployOneYearLockFixture);

        await expect(lock.withdraw()).to.be.revertedWith(
          "You can't withdraw yet"
        );
      ***REMOVED***);

      it("Should revert with the right error if called from another account", async function () {
        const { lock, unlockTime, otherAccount ***REMOVED*** = await loadFixture(
          deployOneYearLockFixture
        );

        // We can increase the time in Hardhat Network
        await time.increaseTo(unlockTime);

        // We use lock.connect() to send a transaction from another account
        await expect(lock.connect(otherAccount).withdraw()).to.be.revertedWith(
          "You aren't the owner"
        );
      ***REMOVED***);

      it("Shouldn't fail if the unlockTime has arrived and the owner calls it", async function () {
        const { lock, unlockTime ***REMOVED*** = await loadFixture(
          deployOneYearLockFixture
        );

        // Transactions are sent using the first signer by default
        await time.increaseTo(unlockTime);

        await expect(lock.withdraw()).not.to.be.reverted;
      ***REMOVED***);
    ***REMOVED***);

    describe("Events", function () {
      it("Should emit an event on withdrawals", async function () {
        const { lock, unlockTime, lockedAmount ***REMOVED*** = await loadFixture(
          deployOneYearLockFixture
        );

        await time.increaseTo(unlockTime);

        await expect(lock.withdraw())
          .to.emit(lock, "Withdrawal")
          .withArgs(lockedAmount, anyValue); // We accept any value as `when` arg
      ***REMOVED***);
    ***REMOVED***);

    describe("Transfers", function () {
      it("Should transfer the funds to the owner", async function () {
        const { lock, unlockTime, lockedAmount, owner ***REMOVED*** = await loadFixture(
          deployOneYearLockFixture
        );

        await time.increaseTo(unlockTime);

        await expect(lock.withdraw()).to.changeEtherBalances(
          [owner, lock],
          [lockedAmount, -lockedAmount]
        );
      ***REMOVED***);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***);