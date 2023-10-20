/*
  Warnings:

  - You are about to drop the column `createdAt` on the `regions` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `regions` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `regions` table. All the data in the column will be lost.
  - Added the required column `regionImage` to the `regions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `regionName` to the `regions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `regions` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "PartnerType" AS ENUM ('GUIDE', 'TRANSPORT', 'ACOMODATION');

-- CreateEnum
CREATE TYPE "PackageavailabilityStatus" AS ENUM ('UPCOMING', 'ONGOING', 'COMPLETED');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'UPFRONT_PAID', 'FULL_PAID');

-- CreateEnum
CREATE TYPE "TouristBookedTourStatus" AS ENUM ('PENDING', 'CONFIRMED', 'CANCELLED');

-- AlterTable
ALTER TABLE "regions" DROP COLUMN "createdAt",
DROP COLUMN "name",
DROP COLUMN "updatedAt",
ADD COLUMN     "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "regionImage" TEXT NOT NULL,
ADD COLUMN     "regionName" TEXT NOT NULL,
ADD COLUMN     "updated_at" TIMESTAMPTZ NOT NULL;

-- CreateTable
CREATE TABLE "cities" (
    "id" TEXT NOT NULL,
    "cityName" TEXT NOT NULL,
    "cityImage" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,
    "regionId" TEXT NOT NULL,

    CONSTRAINT "cities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "destinations" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "latitude" DOUBLE PRECISION NOT NULL,
    "region_id" TEXT NOT NULL,
    "city_id" TEXT NOT NULL,
    "destinationImages" JSONB[],
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "destinations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attractions" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "destination_id" TEXT NOT NULL,

    CONSTRAINT "attractions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AvailableDate" (
    "id" TEXT NOT NULL,
    "destinationId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "capacity" INTEGER NOT NULL,
    "duration" INTEGER NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "AvailableDate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tourists" (
    "id" TEXT NOT NULL,
    "tourist_id" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "middle_name" TEXT,
    "last_name" TEXT,
    "profileImage" TEXT,
    "contactNo" TEXT NOT NULL,
    "gender" TEXT NOT NULL,
    "bloodGroup" TEXT NOT NULL,
    "emergencyContactNo" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,
    "cityId" TEXT NOT NULL,
    "regionId" TEXT NOT NULL,

    CONSTRAINT "tourists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "partners" (
    "id" TEXT NOT NULL,
    "partner_id" TEXT NOT NULL,
    "partnerType" "PartnerType" NOT NULL,
    "first_name" TEXT NOT NULL,
    "middle_name" TEXT,
    "last_name" TEXT,
    "profileImage" TEXT NOT NULL,
    "contactNo" TEXT NOT NULL,
    "gender" TEXT NOT NULL,
    "designation" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "cityId" TEXT NOT NULL,
    "regionId" TEXT NOT NULL,

    CONSTRAINT "partners_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tour_partners" (
    "tour_package_id" TEXT NOT NULL,
    "partner_id" TEXT NOT NULL,

    CONSTRAINT "tour_partners_pkey" PRIMARY KEY ("tour_package_id","partner_id")
);

-- CreateTable
CREATE TABLE "tour_types" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "maxCapacity" INTEGER NOT NULL DEFAULT 0,
    "tour_duratin" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "tour_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tour_categories" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "tour_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tour_packages" (
    "id" TEXT NOT NULL,
    "destination_id" TEXT NOT NULL,
    "tour_type_id" TEXT NOT NULL,
    "tour_category_id" TEXT NOT NULL,
    "tour_budget" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,
    "status" "PackageavailabilityStatus" NOT NULL,

    CONSTRAINT "tour_packages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tour_itinerary" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "startTime" TEXT NOT NULL,
    "endTime" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,
    "tour_category_id" TEXT NOT NULL,
    "destination_id" TEXT NOT NULL,
    "tour_package_id" TEXT,
    "partnerId" TEXT,

    CONSTRAINT "tour_itinerary_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tourist_package_bookings" (
    "id" TEXT NOT NULL,
    "isConfirmed" BOOLEAN DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "tour_package_id" TEXT NOT NULL,
    "tourist_id" TEXT NOT NULL,

    CONSTRAINT "tourist_package_bookings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tour_payments" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,
    "tourist_id" TEXT NOT NULL,
    "tour_package_id" TEXT NOT NULL,
    "fullPaymentAmount" INTEGER DEFAULT 0,
    "upfrontPaymentAmount" INTEGER DEFAULT 0,
    "totalDueAmount" INTEGER DEFAULT 0,
    "totalPaidAmount" INTEGER DEFAULT 0,
    "paymentStatus" "PaymentStatus" DEFAULT 'PENDING',

    CONSTRAINT "tour_payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tourist_booked_tours" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,
    "tourist_id" TEXT NOT NULL,
    "status" "TouristBookedTourStatus" DEFAULT 'PENDING',
    "tour_package_id" TEXT NOT NULL,

    CONSTRAINT "tourist_booked_tours_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tourist_reviews" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,
    "tourist_id" TEXT NOT NULL,
    "touristBookedTourId" TEXT NOT NULL,
    "comment" TEXT NOT NULL,
    "rating" DOUBLE PRECISION NOT NULL DEFAULT 0,

    CONSTRAINT "tourist_reviews_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "available_dates" ON "AvailableDate"("destinationId", "date");

-- AddForeignKey
ALTER TABLE "cities" ADD CONSTRAINT "cities_regionId_fkey" FOREIGN KEY ("regionId") REFERENCES "regions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "destinations" ADD CONSTRAINT "destinations_region_id_fkey" FOREIGN KEY ("region_id") REFERENCES "regions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "destinations" ADD CONSTRAINT "destinations_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attractions" ADD CONSTRAINT "attractions_destination_id_fkey" FOREIGN KEY ("destination_id") REFERENCES "destinations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AvailableDate" ADD CONSTRAINT "AvailableDate_destinationId_fkey" FOREIGN KEY ("destinationId") REFERENCES "destinations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tourists" ADD CONSTRAINT "tourists_cityId_fkey" FOREIGN KEY ("cityId") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tourists" ADD CONSTRAINT "tourists_regionId_fkey" FOREIGN KEY ("regionId") REFERENCES "regions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "partners" ADD CONSTRAINT "partners_cityId_fkey" FOREIGN KEY ("cityId") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "partners" ADD CONSTRAINT "partners_regionId_fkey" FOREIGN KEY ("regionId") REFERENCES "regions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_partners" ADD CONSTRAINT "tour_partners_tour_package_id_fkey" FOREIGN KEY ("tour_package_id") REFERENCES "tour_packages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_partners" ADD CONSTRAINT "tour_partners_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "partners"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_packages" ADD CONSTRAINT "tour_packages_destination_id_fkey" FOREIGN KEY ("destination_id") REFERENCES "destinations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_packages" ADD CONSTRAINT "tour_packages_tour_type_id_fkey" FOREIGN KEY ("tour_type_id") REFERENCES "tour_types"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_packages" ADD CONSTRAINT "tour_packages_tour_category_id_fkey" FOREIGN KEY ("tour_category_id") REFERENCES "tour_categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_itinerary" ADD CONSTRAINT "tour_itinerary_tour_category_id_fkey" FOREIGN KEY ("tour_category_id") REFERENCES "tour_categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_itinerary" ADD CONSTRAINT "tour_itinerary_destination_id_fkey" FOREIGN KEY ("destination_id") REFERENCES "destinations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_itinerary" ADD CONSTRAINT "tour_itinerary_tour_package_id_fkey" FOREIGN KEY ("tour_package_id") REFERENCES "tour_packages"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_itinerary" ADD CONSTRAINT "tour_itinerary_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "partners"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tourist_package_bookings" ADD CONSTRAINT "tourist_package_bookings_tour_package_id_fkey" FOREIGN KEY ("tour_package_id") REFERENCES "tour_packages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tourist_package_bookings" ADD CONSTRAINT "tourist_package_bookings_tourist_id_fkey" FOREIGN KEY ("tourist_id") REFERENCES "tourists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_payments" ADD CONSTRAINT "tour_payments_tourist_id_fkey" FOREIGN KEY ("tourist_id") REFERENCES "tourists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_payments" ADD CONSTRAINT "tour_payments_tour_package_id_fkey" FOREIGN KEY ("tour_package_id") REFERENCES "tour_packages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tourist_booked_tours" ADD CONSTRAINT "tourist_booked_tours_tourist_id_fkey" FOREIGN KEY ("tourist_id") REFERENCES "tourists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tourist_booked_tours" ADD CONSTRAINT "tourist_booked_tours_tour_package_id_fkey" FOREIGN KEY ("tour_package_id") REFERENCES "tour_packages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tourist_reviews" ADD CONSTRAINT "tourist_reviews_tourist_id_fkey" FOREIGN KEY ("tourist_id") REFERENCES "tourists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tourist_reviews" ADD CONSTRAINT "tourist_reviews_touristBookedTourId_fkey" FOREIGN KEY ("touristBookedTourId") REFERENCES "tourist_booked_tours"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
