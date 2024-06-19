import {
  time,
  loadFixture,
<<<<<<< HEAD
***REMOVED*** from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue ***REMOVED*** from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect ***REMOVED*** from "chai";
=======
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212
import hre from "hardhat";

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
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const Lock = await hre.ethers.getContractFactory("Lock");
<<<<<<< HEAD
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
=======
    const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

    return { lock, unlockTime, lockedAmount, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should set the right unlockTime", async function () {
      const { lock, unlockTime } = await loadFixture(deployOneYearLockFixture);

      expect(await lock.unlockTime()).to.equal(unlockTime);
    });

    it("Should set the right owner", async function () {
      const { lock, owner } = await loadFixture(deployOneYearLockFixture);

      expect(await lock.owner()).to.equal(owner.address);
    });

    it("Should receive and store the funds to lock", async function () {
      const { lock, lockedAmount } = await loadFixture(
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212
        deployOneYearLockFixture
      );

      expect(await hre.ethers.provider.getBalance(lock.target)).to.equal(
        lockedAmount
      );
<<<<<<< HEAD
    ***REMOVED***);
=======
    });
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212

    it("Should fail if the unlockTime is not in the future", async function () {
      // We don't use the fixture here because we want a different deployment
      const latestTime = await time.latest();
      const Lock = await hre.ethers.getContractFactory("Lock");
<<<<<<< HEAD
      await expect(Lock.deploy(latestTime, { value: 1 ***REMOVED***)).to.be.revertedWith(
        "Unlock time should be in the future"
      );
    ***REMOVED***);
  ***REMOVED***);
=======
      await expect(Lock.deploy(latestTime, { value: 1 })).to.be.revertedWith(
        "Unlock time should be in the future"
      );
    });
  });
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212

  describe("Withdrawals", function () {
    describe("Validations", function () {
      it("Should revert with the right error if called too soon", async function () {
<<<<<<< HEAD
        const { lock ***REMOVED*** = await loadFixture(deployOneYearLockFixture);
=======
        const { lock } = await loadFixture(deployOneYearLockFixture);
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212

        await expect(lock.withdraw()).to.be.revertedWith(
          "You can't withdraw yet"
        );
<<<<<<< HEAD
      ***REMOVED***);

      it("Should revert with the right error if called from another account", async function () {
        const { lock, unlockTime, otherAccount ***REMOVED*** = await loadFixture(
=======
      });

      it("Should revert with the right error if called from another account", async function () {
        const { lock, unlockTime, otherAccount } = await loadFixture(
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212
          deployOneYearLockFixture
        );

        // We can increase the time in Hardhat Network
        await time.increaseTo(unlockTime);

        // We use lock.connect() to send a transaction from another account
        await expect(lock.connect(otherAccount).withdraw()).to.be.revertedWith(
          "You aren't the owner"
        );
<<<<<<< HEAD
      ***REMOVED***);

      it("Shouldn't fail if the unlockTime has arrived and the owner calls it", async function () {
        const { lock, unlockTime ***REMOVED*** = await loadFixture(
=======
      });

      it("Shouldn't fail if the unlockTime has arrived and the owner calls it", async function () {
        const { lock, unlockTime } = await loadFixture(
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212
          deployOneYearLockFixture
        );

        // Transactions are sent using the first signer by default
        await time.increaseTo(unlockTime);

        await expect(lock.withdraw()).not.to.be.reverted;
<<<<<<< HEAD
      ***REMOVED***);
    ***REMOVED***);

    describe("Events", function () {
      it("Should emit an event on withdrawals", async function () {
        const { lock, unlockTime, lockedAmount ***REMOVED*** = await loadFixture(
=======
      });
    });

    describe("Events", function () {
      it("Should emit an event on withdrawals", async function () {
        const { lock, unlockTime, lockedAmount } = await loadFixture(
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212
          deployOneYearLockFixture
        );

        await time.increaseTo(unlockTime);

        await expect(lock.withdraw())
          .to.emit(lock, "Withdrawal")
          .withArgs(lockedAmount, anyValue); // We accept any value as `when` arg
<<<<<<< HEAD
      ***REMOVED***);
    ***REMOVED***);

    describe("Transfers", function () {
      it("Should transfer the funds to the owner", async function () {
        const { lock, unlockTime, lockedAmount, owner ***REMOVED*** = await loadFixture(
=======
      });
    });

    describe("Transfers", function () {
      it("Should transfer the funds to the owner", async function () {
        const { lock, unlockTime, lockedAmount, owner } = await loadFixture(
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212
          deployOneYearLockFixture
        );

        await time.increaseTo(unlockTime);

        await expect(lock.withdraw()).to.changeEtherBalances(
          [owner, lock],
          [lockedAmount, -lockedAmount]
        );
<<<<<<< HEAD
      ***REMOVED***);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***);
=======
      });
    });
  });
});
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212
