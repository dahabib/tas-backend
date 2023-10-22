import { Request, Response } from 'express';
import httpStatus from 'http-status';
import config from '../../../config';
import catchAsync from '../../../shared/catchAsync';
import sendResponse from '../../../shared/sendResponse';
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

// Login User - Controller
const loginUser = catchAsync(async (req: Request, res: Response) => {
  const result = await AuthService.loginUser(req.body);

  const { refreshToken, ...others } = result;

  // set refreshToken into cookie
  const cookieOptions = {
    secure: config.env === 'production',
    httpOnly: true,
  };
  res.cookie('refreshToken', refreshToken, cookieOptions);

  // deleting refreshToken from user after setting into cookie
  if ('refreshToken' in result) {
    delete result.refreshToken;
  }

  sendResponse(res, {
    statusCode: httpStatus.OK,
    success: true,
    message: 'User logged in successfully!',
    data: others,
  });
});

export const AuthController = {
  signupUser,
  loginUser,
};
