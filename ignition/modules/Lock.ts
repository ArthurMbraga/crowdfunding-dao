<<<<<<< HEAD
import { buildModule ***REMOVED*** from "@nomicfoundation/hardhat-ignition/modules";
=======
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212

const JAN_1ST_2030 = 1893456000;
const ONE_GWEI: bigint = 1_000_000_000n;

const LockModule = buildModule("LockModule", (m) => {
  const unlockTime = m.getParameter("unlockTime", JAN_1ST_2030);
  const lockedAmount = m.getParameter("lockedAmount", ONE_GWEI);

  const lock = m.contract("Lock", [unlockTime], {
    value: lockedAmount,
<<<<<<< HEAD
  ***REMOVED***);

  return { lock ***REMOVED***;
***REMOVED***);
=======
  });

  return { lock };
});
>>>>>>> d80b7584f8cac5c93b844ad0812b2a4408b2d212

export default LockModule;
