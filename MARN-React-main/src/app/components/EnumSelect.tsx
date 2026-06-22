import { Label } from './ui/label'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from './ui/select'
import { useEnumOptions, type EnumEndpoint } from '@/hooks/useEnumOptions'

interface EnumSelectProps {
  id: string
  label: string
  endpoint: EnumEndpoint
  value: string
  onChange: (value: string) => void
  placeholder?: string
}

export function EnumSelect({
  id,
  label,
  endpoint,
  value,
  onChange,
  placeholder,
}: EnumSelectProps) {
  const { options, loading } = useEnumOptions(endpoint)

  return (
    <div>
      <Label htmlFor={id} className="text-[#1a1a1a] mb-2 block">
        {label}
      </Label>
      <Select value={value} onValueChange={onChange} disabled={loading}>
        <SelectTrigger
          id={id}
          className="bg-white rounded-xl border-[#3A6EA5]/20"
        >
          <SelectValue
            placeholder={placeholder ?? `Select ${label.toLowerCase()}`}
          />
        </SelectTrigger>
        <SelectContent className="max-h-[300px]">
          {options.map((option) => (
            <SelectItem key={option.id} value={option.name}>
              {option.displayName ?? option.name}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
    </div>
  )
}
