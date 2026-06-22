import { useRef, useState } from 'react'
import { Upload, X } from 'lucide-react'
import { toast } from 'sonner'
import { cn } from './utils'

const MAX_SIZE_MB = 2

interface FileUploadProps {
  id: string
  value?: File | null
  initialUrl?: string | null
  onChange: (file: File) => void
  onClear?: () => void
  accept?: string
  className?: string
}

export function FileUpload({
  id,
  value,
  initialUrl,
  onChange,
  onClear,
  accept = 'image/*',
  className,
}: FileUploadProps) {
  const [localPreview, setLocalPreview] = useState<string | null>(null)
  const inputRef = useRef<HTMLInputElement>(null)

  // localPreview (newly selected file) takes precedence over the server URL
  const displayUrl = localPreview ?? initialUrl ?? null

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file) return

    if (file.size > MAX_SIZE_MB * 1024 * 1024) {
      toast.error(
        `Image size exceeds ${MAX_SIZE_MB}MB. Please choose a smaller file.`,
      )
      e.target.value = ''
      return
    }

    if (localPreview) URL.revokeObjectURL(localPreview)
    onChange(file)
    setLocalPreview(URL.createObjectURL(file))
  }

  const handleClear = (e: React.MouseEvent) => {
    e.preventDefault()
    e.stopPropagation()
    if (localPreview) URL.revokeObjectURL(localPreview)
    setLocalPreview(null)
    if (inputRef.current) inputRef.current.value = ''
    onClear?.()
  }

  return (
    <div className={cn('relative', className)}>
      <input
        ref={inputRef}
        type="file"
        id={id}
        accept={accept}
        onChange={handleChange}
        className="hidden"
      />
      <label
        htmlFor={id}
        className={cn(
          'flex flex-col items-center justify-center w-full h-40 rounded-xl border-2 border-dashed transition-colors cursor-pointer overflow-hidden',
          displayUrl
            ? 'border-[#3A6EA5]/40'
            : 'bg-white border-[#3A6EA5]/20 hover:border-[#3A6EA5]/40',
        )}
      >
        {displayUrl ? (
          <img
            src={displayUrl}
            alt="Uploaded preview"
            className="w-full h-full object-contain"
          />
        ) : (
          <>
            <Upload className="w-8 h-8 text-[#4a5565] mb-2" />
            <span className="text-sm text-[#4a5565]">
              {value ? value.name : 'Click to upload'}
            </span>
          </>
        )}
      </label>

      {displayUrl && (
        <button
          onClick={handleClear}
          className="absolute top-2 right-2 w-6 h-6 rounded-full bg-black/50 hover:bg-black/70 flex items-center justify-center transition-colors"
          aria-label="Remove image"
        >
          <X className="w-3.5 h-3.5 text-white" />
        </button>
      )}
    </div>
  )
}
