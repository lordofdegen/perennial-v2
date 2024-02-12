// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

import { Token18 } from "@equilibria/root/token/types/Token18.sol";
import { IMarket, RiskParameter } from "@equilibria/perennial-v2/contracts/interfaces/IMarket.sol";

interface ICoordinator {
    function setFeeClaimer(address feeClaimer_) external;
    function setRiskParameterUpdater(address riskParameterUpdater_) external;
    function claimFee(IMarket market) external;
    function updateRiskParameter(IMarket market, RiskParameter calldata riskParameter) external;
    function withdraw(Token18 token, address beneficiary) external;

    error NotFeeClaimer();
    error NotRiskParameterUpdater();
    error NotFeeWithdrawer();
}
