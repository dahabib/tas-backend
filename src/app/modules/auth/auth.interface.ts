export type IUserLogin = {
  email: string;
  password: string;
};

export type IUserLoginResonse = {
  accessToken: string;
  refreshToken?: string;
};

// export type IUserLoginResonse = {
//   statusCode: number;
//   success: boolean;
//   message: string;
//   data: string;
// };

export type IRefreshTokenResponse = {
  accessToken: string;
};
