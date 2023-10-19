export type IUserLogin = {
  email: string;
  password: string;
};

export type IUserLoginResonse = {
  token: string;
};

export type IRefreshTokenResponse = {
  accessToken: string;
};
