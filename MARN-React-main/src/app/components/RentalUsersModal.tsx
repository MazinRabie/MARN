import { Dialog, DialogContent, DialogHeader, DialogTitle } from './ui/dialog'
import { Button } from './ui/button'
import { Calendar, Download, User } from 'lucide-react'
import { motion } from 'motion/react'

interface RentalUser {
  id: string
  name: string
  photo: string
  rentalEndDate: string
  contractId: string
}

interface RentalUsersModalProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  users: RentalUser[]
  propertyName?: string
}

export function RentalUsersModal({
  open,
  onOpenChange,
  users,
  propertyName,
}: RentalUsersModalProps) {
  const handleDownloadContract = (user: RentalUser) => {
    // Simulate contract download
    console.log(
      `Downloading contract for ${user.name} - Contract ID: ${user.contractId}`,
    )
    // In production: trigger actual file download
  }

  const getDaysUntilEnd = (endDate: string) => {
    const today = new Date()
    const end = new Date(endDate)
    const diffTime = end.getTime() - today.getTime()
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
    return diffDays
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-white rounded-3xl max-w-2xl max-h-[80vh] overflow-hidden flex flex-col">
        <DialogHeader>
          <DialogTitle className="text-2xl text-[#1a1a1a]">
            Current Tenants {propertyName && `- ${propertyName}`}
          </DialogTitle>
          <p className="text-sm text-[#4a5565] mt-1">
            {users.length} active {users.length === 1 ? 'tenant' : 'tenants'}
          </p>
        </DialogHeader>

        <div className="overflow-y-auto flex-1 pr-2 space-y-3">
          {users.map((user, index) => {
            const daysRemaining = getDaysUntilEnd(user.rentalEndDate)
            const isExpiringSoon = daysRemaining <= 30

            return (
              <motion.div
                key={user.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.05 }}
                className="bg-[#F2F4F6] rounded-2xl p-4 hover:shadow-md transition-shadow"
              >
                <div className="flex items-center gap-4">
                  {/* Profile Photo */}
                  <div className="relative flex-shrink-0">
                    <img
                      src={user.photo}
                      alt={user.name}
                      className="w-16 h-16 rounded-xl object-cover shadow-md"
                    />
                    <div className="absolute -bottom-1 -right-1 w-5 h-5 bg-green-500 rounded-full border-2 border-white"></div>
                  </div>

                  {/* User Info */}
                  <div className="flex-1 min-w-0">
                    <h3 className="font-semibold text-[#1a1a1a] text-lg mb-1">
                      {user.name}
                    </h3>

                    <div className="flex items-center gap-2 mb-2">
                      <Calendar className="w-4 h-4 text-[#4a5565]" />
                      <span className="text-sm text-[#4a5565]">
                        Ends:{' '}
                        <span className="font-medium">
                          {user.rentalEndDate}
                        </span>
                      </span>
                    </div>

                    {/* Days Remaining Badge */}
                    <div
                      className={`inline-flex items-center px-3 py-1 rounded-lg text-xs font-medium ${
                        isExpiringSoon
                          ? 'bg-orange-100 text-orange-700'
                          : 'bg-green-100 text-green-700'
                      }`}
                    >
                      {daysRemaining > 0
                        ? `${daysRemaining} days remaining`
                        : daysRemaining === 0
                          ? 'Ends today'
                          : `Expired ${Math.abs(daysRemaining)} days ago`}
                    </div>
                  </div>

                  {/* Download Button */}
                  <Button
                    onClick={() => handleDownloadContract(user)}
                    className="bg-gradient-to-r from-[#3A6EA5] to-[#9CBBDC] hover:from-[#2a5a8a] hover:to-[#3A6EA5] text-white rounded-xl flex-shrink-0"
                    size="sm"
                  >
                    <Download className="w-4 h-4 mr-2" />
                    Contract
                  </Button>
                </div>
              </motion.div>
            )
          })}

          {users.length === 0 && (
            <div className="text-center py-12">
              <div className="w-20 h-20 rounded-full bg-[#F2F4F6] flex items-center justify-center mx-auto mb-4">
                <User className="w-10 h-10 text-[#4a5565]" />
              </div>
              <p className="text-[#4a5565]">No active tenants</p>
            </div>
          )}
        </div>
      </DialogContent>
    </Dialog>
  )
}
