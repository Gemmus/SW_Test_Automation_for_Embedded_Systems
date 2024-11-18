from faker import Faker
from faker_vehicle import VehicleProvider

class FakerVehicleLibrary:

    ROBOT_LIBRARY_SCOPE = 'SUITE'

    def __init__(self):
        self.fake = Faker()
        self.fake.add_provider(VehicleProvider)

    def generate_vehicle_make(self):
        """
        Generate a random vehicle make.
        """
        return self.fake.vehicle_make()

    def generate_vehicle_model(self):
        """
        Generate a random vehicle model.
        """
        return self.fake.vehicle_model()