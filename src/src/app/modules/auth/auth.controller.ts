import { Request, Response } from 'express';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchAsync';
import sendResponse from '../../../shared/sendResponse';
import { IUserLoginResonse } from '../user/user.interface';
import { AuthService } from './auth.service';

// Signup User
const signupUser = catchAsync(async (req: Request, res: Response) => {
  const result = await AuthService.signupUser(req.body);
  sendResponse(res, {
    statusCode: httpStatus.CREATED,
    success: true,
    message: 'User signed up successfully!',
    data: result,
  });
});

const loginUser = catchAsync(async (req: Request, res: Response) => {
  const result = await AuthService.loginUser(req.body);

  sendResponse<IUserLoginResonse>(res, {
    success: true,
    statusCode: httpStatus.OK,
    message: 'User logged in successfully!',
    token: result,
  });
});

export const AuthController = {
  signupUser,
  loginUser,
};
