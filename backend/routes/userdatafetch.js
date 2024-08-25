import express from 'express';
const router = express.Router();
import {
    getcalorieburntcontroller, getcalorieconsumedcontroller, getstepscontroller
    , getMealCardDetails, getworkoutdetails,
    GetWaterIntakeController,getsleepdatacontroller,
    getuserdetails
} from '../controllers/userdatafetchcontroller.js';

import authMiddleware from '../middleware/auth.js';


router.get('/getuserdetails',authMiddleware,getuserdetails);
router.get('/getwaterintake', authMiddleware, GetWaterIntakeController);
router.get('/getcalorieburnt', authMiddleware, getcalorieburntcontroller);
router.get('/getcalorieconsumed', authMiddleware, getcalorieconsumedcontroller);
router.get('/getstepswalked', authMiddleware, getstepscontroller);
router.get('/getworkoutdetails', authMiddleware,getworkoutdetails);
router.get('/getmealdata',authMiddleware, getMealCardDetails);
router.get('/getsleepdata',authMiddleware, getsleepdatacontroller);
export default router;