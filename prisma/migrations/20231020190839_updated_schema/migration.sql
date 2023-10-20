/*
  Warnings:

  - You are about to drop the column `destinationId` on the `AvailableDate` table. All the data in the column will be lost.
  - You are about to drop the column `cityImage` on the `cities` table. All the data in the column will be lost.
  - You are about to drop the column `cityName` on the `cities` table. All the data in the column will be lost.
  - You are about to drop the column `destinationImages` on the `destinations` table. All the data in the column will be lost.
  - You are about to drop the column `cityId` on the `partners` table. All the data in the column will be lost.
  - You are about to drop the column `partnerType` on the `partners` table. All the data in the column will be lost.
  - You are about to drop the column `profileImage` on the `partners` table. All the data in the column will be lost.
  - You are about to drop the column `regionId` on the `partners` table. All the data in the column will be lost.
  - You are about to drop the column `regionImage` on the `regions` table. All the data in the column will be lost.
  - You are about to drop the column `regionName` on the `regions` table. All the data in the column will be lost.
  - You are about to drop the column `endTime` on the `tour_itinerary` table. All the data in the column will be lost.
  - You are about to drop the column `startTime` on the `tour_itinerary` table. All the data in the column will be lost.
  - You are about to drop the column `fullPaymentAmount` on the `tour_payments` table. All the data in the column will be lost.
  - You are about to drop the column `paymentStatus` on the `tour_payments` table. All the data in the column will be lost.
  - You are about to drop the column `totalDueAmount` on the `tour_payments` table. All the data in the column will be lost.
  - You are about to drop the column `totalPaidAmount` on the `tour_payments` table. All the data in the column will be lost.
  - You are about to drop the column `upfrontPaymentAmount` on the `tour_payments` table. All the data in the column will be lost.
  - You are about to drop the column `maxCapacity` on the `tour_types` table. All the data in the column will be lost.
  - You are about to drop the column `isConfirmed` on the `tourist_package_bookings` table. All the data in the column will be lost.
  - You are about to drop the column `touristBookedTourId` on the `tourist_reviews` table. All the data in the column will be lost.
  - You are about to drop the column `bloodGroup` on the `tourists` table. All the data in the column will be lost.
  - You are about to drop the column `cityId` on the `tourists` table. All the data in the column will be lost.
  - You are about to drop the column `contactNo` on the `tourists` table. All the data in the column will be lost.
  - You are about to drop the column `emergencyContactNo` on the `tourists` table. All the data in the column will be lost.
  - You are about to drop the column `profileImage` on the `tourists` table. All the data in the column will be lost.
  - Added the required column `destination_id` to the `AvailableDate` table without a default value. This is not possible if the table is not empty.
  - Added the required column `city_name` to the `cities` table without a default value. This is not possible if the table is not empty.
  - Added the required column `city_id` to the `partners` table without a default value. This is not possible if the table is not empty.
  - Added the required column `partner_type` to the `partners` table without a default value. This is not possible if the table is not empty.
  - Added the required column `profile_image` to the `partners` table without a default value. This is not possible if the table is not empty.
  - Added the required column `region_id` to the `partners` table without a default value. This is not possible if the table is not empty.
  - Added the required column `region_name` to the `regions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `start_time` to the `tour_itinerary` table without a default value. This is not possible if the table is not empty.
  - Added the required column `tourist_booked_tour_id` to the `tourist_reviews` table without a default value. This is not possible if the table is not empty.
  - Added the required column `blood_group` to the `tourists` table without a default value. This is not possible if the table is not empty.
  - Added the required column `city_id` to the `tourists` table without a default value. This is not possible if the table is not empty.
  - Added the required column `contact_no` to the `tourists` table without a default value. This is not possible if the table is not empty.
  - Added the required column `emergency_contact_no` to the `tourists` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "AvailableDate" DROP CONSTRAINT "AvailableDate_destinationId_fkey";

-- DropForeignKey
ALTER TABLE "partners" DROP CONSTRAINT "partners_cityId_fkey";

-- DropForeignKey
ALTER TABLE "partners" DROP CONSTRAINT "partners_regionId_fkey";

-- DropForeignKey
ALTER TABLE "tourist_reviews" DROP CONSTRAINT "tourist_reviews_touristBookedTourId_fkey";

-- DropForeignKey
ALTER TABLE "tourists" DROP CONSTRAINT "tourists_cityId_fkey";

-- DropIndex
DROP INDEX "available_dates";

-- AlterTable
ALTER TABLE "AvailableDate" DROP COLUMN "destinationId",
ADD COLUMN     "destination_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "cities" DROP COLUMN "cityImage",
DROP COLUMN "cityName",
ADD COLUMN     "city_images" JSONB[],
ADD COLUMN     "city_name" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "destinations" DROP COLUMN "destinationImages",
ADD COLUMN     "destination_images" JSONB[];

-- AlterTable
ALTER TABLE "partners" DROP COLUMN "cityId",
DROP COLUMN "partnerType",
DROP COLUMN "profileImage",
DROP COLUMN "regionId",
ADD COLUMN     "city_id" TEXT NOT NULL,
ADD COLUMN     "partner_type" "PartnerType" NOT NULL,
ADD COLUMN     "profile_image" TEXT NOT NULL,
ADD COLUMN     "region_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "regions" DROP COLUMN "regionImage",
DROP COLUMN "regionName",
ADD COLUMN     "region_images" JSONB[],
ADD COLUMN     "region_name" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "tour_itinerary" DROP COLUMN "endTime",
DROP COLUMN "startTime",
ADD COLUMN     "end_time" TEXT,
ADD COLUMN     "start_time" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "tour_payments" DROP COLUMN "fullPaymentAmount",
DROP COLUMN "paymentStatus",
DROP COLUMN "totalDueAmount",
DROP COLUMN "totalPaidAmount",
DROP COLUMN "upfrontPaymentAmount",
ADD COLUMN     "full_payment_amount" INTEGER DEFAULT 0,
ADD COLUMN     "payment_status" "PaymentStatus" DEFAULT 'PENDING',
ADD COLUMN     "total_due_amount" INTEGER DEFAULT 0,
ADD COLUMN     "total_paid_amount" INTEGER DEFAULT 0,
ADD COLUMN     "upfront_payment_amount" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "tour_types" DROP COLUMN "maxCapacity",
ADD COLUMN     "max_capacity" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "tourist_package_bookings" DROP COLUMN "isConfirmed",
ADD COLUMN     "is_confirmed" BOOLEAN DEFAULT false;

-- AlterTable
ALTER TABLE "tourist_reviews" DROP COLUMN "touristBookedTourId",
ADD COLUMN     "tourist_booked_tour_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "tourists" DROP COLUMN "bloodGroup",
DROP COLUMN "cityId",
DROP COLUMN "contactNo",
DROP COLUMN "emergencyContactNo",
DROP COLUMN "profileImage",
ADD COLUMN     "blood_group" TEXT NOT NULL,
ADD COLUMN     "city_id" TEXT NOT NULL,
ADD COLUMN     "contact_no" TEXT NOT NULL,
ADD COLUMN     "emergency_contact_no" TEXT NOT NULL,
ADD COLUMN     "profile_image" TEXT;

-- CreateIndex
CREATE INDEX "available_dates" ON "AvailableDate"("destination_id", "date");

-- AddForeignKey
ALTER TABLE "AvailableDate" ADD CONSTRAINT "AvailableDate_destination_id_fkey" FOREIGN KEY ("destination_id") REFERENCES "destinations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tourists" ADD CONSTRAINT "tourists_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "partners" ADD CONSTRAINT "partners_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "partners" ADD CONSTRAINT "partners_region_id_fkey" FOREIGN KEY ("region_id") REFERENCES "regions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tourist_reviews" ADD CONSTRAINT "tourist_reviews_tourist_booked_tour_id_fkey" FOREIGN KEY ("tourist_booked_tour_id") REFERENCES "tourist_booked_tours"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
