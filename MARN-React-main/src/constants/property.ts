import {
  Home,
  CheckCircle,
  Upload,
  DollarSign,
  Calendar,
  FileText,
  Wifi,
  Car,
  Wind,
  Flame,
  Shirt,
  Dumbbell,
  Waves,
  Dog,
} from 'lucide-react'

export const PROPERTY_STEPS = [
  { id: 1, title: 'Property Details', icon: Home },
  { id: 2, title: 'Amenities', icon: CheckCircle },
  { id: 3, title: 'Photos', icon: Upload },
  { id: 4, title: 'Pricing', icon: DollarSign },
  { id: 5, title: 'Availability', icon: Calendar },
  { id: 6, title: 'Legal Docs', icon: FileText },
]

export const PROPERTY_AMENITIES = [
  { name: 'WiFi', icon: Wifi },
  { name: 'Parking', icon: Car },
  { name: 'Air Conditioning', icon: Wind },
  { name: 'Heating', icon: Flame },
  { name: 'Washer/Dryer', icon: Shirt },
  { name: 'Gym', icon: Dumbbell },
  { name: 'Pool', icon: Waves },
  { name: 'Pet Friendly', icon: Dog },
]
