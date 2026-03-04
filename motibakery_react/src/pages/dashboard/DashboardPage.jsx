import { PageHeader } from '@/components/shared/PageHeader';
import { StatusBadge } from '@/components/shared/StatusBadge';

const stats = [
  { label: 'Total Orders Today', value: '12' },
  { label: 'Active Cakes', value: '34' },
  { label: 'Users', value: '5' },
  { label: 'Pending Orders', value: '3' },
];

const recentOrders = [
  { id: '#ORD-0042', cake: 'Black Forest', source: 'Counter A', slot: '12 Mar, 3PM', status: 'prepared' },
  { id: '#ORD-0041', cake: 'Truffle Royale', source: 'Counter A', slot: '12 Mar, 5PM', status: 'in_progress' },
  { id: '#ORD-0040', cake: 'Mango Delight', source: 'Counter B', slot: '14 Mar, 6PM', status: 'new' },
];

export function DashboardPage() {
  return (
    <div>
      <PageHeader title="Dashboard" subtitle="Good morning, Admin!" />

      <section className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        {stats.map((stat) => (
          <div key={stat.label} className="rounded-xl border border-gray-200 bg-white p-5 shadow-card">
            <p className="text-sm text-gray-500">{stat.label}</p>
            <p className="mt-2 text-3xl font-bold text-gray-900">{stat.value}</p>
          </div>
        ))}
      </section>

      <section className="mt-8 rounded-xl border border-gray-200 bg-white p-6 shadow-card">
        <h3 className="text-lg font-semibold">Recent Orders</h3>
        <div className="mt-4 space-y-3">
          {recentOrders.map((order) => (
            <div key={order.id} className="flex flex-wrap items-center gap-3 rounded-md border border-gray-100 p-3">
              <p className="font-mono text-sm text-gray-700">{order.id}</p>
              <p className="text-sm font-medium text-gray-900">{order.cake}</p>
              <p className="text-sm text-gray-500">{order.source}</p>
              <p className="text-sm text-gray-500">{order.slot}</p>
              <div className="ml-auto">
                <StatusBadge status={order.status} />
              </div>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}
